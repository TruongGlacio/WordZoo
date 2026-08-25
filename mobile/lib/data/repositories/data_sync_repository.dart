import 'dart:convert';
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wordzoo/data/datasources/data_manager.dart';
import 'package:wordzoo/data/repositories/r2_repository.dart';
import 'package:wordzoo/data/service/zip_asset_service.dart';
import 'package:wordzoo/utils/premium_entity_manager.dart';
import '../models/word_zoo_data.dart';
import 'package:wordzoo/utils/constants.dart';
import 'package:wordzoo/utils/logger.dart';
import 'package:wordzoo/utils/media_cache_service.dart';
import 'package:http/http.dart' as http;

abstract class DataSyncRepository {
  Future<WordZooData?> getCachedData();
  Future<void> syncData();
  Future<bool> needsUpdate();
  Future<void> precacheAssets();
  Future<WordZooData> getData();
  Future<Map<String, String>> getLocalMediaPaths();
  Future<void> syncCategoryZip(Map<String, dynamic> json);
}

class DataSyncRepositoryImpl implements DataSyncRepository {
  DataSyncRepositoryImpl._internal();
  static final DataSyncRepositoryImpl _instance = DataSyncRepositoryImpl._internal();
  static DataSyncRepositoryImpl get instance => _instance;
  factory DataSyncRepositoryImpl() => _instance;

  final SupabaseClient _client = Supabase.instance.client;
  final String dataBucketName = 'data';
  final String assetsBucketName = 'assets';
  @override
  Future<WordZooData?> getCachedData() async {
    try {
      final box = Hive.box<String>('app_data');
      final jsonStr = box.get(AppConstants.dataJsonKey);

      if (jsonStr == null) {
        AppLogger.w('getCachedData: no cached data found');
        return null;
      }

      AppLogger.i('getCachedData: loading cached data...');
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      final data = WordZooData.fromJson(json);
      WordZooData data1 = PremiumEntityManager().setUpWordZooDataWhenInitial(wordZooData: data);
      DataManager().setCategories(wordZooData: data1);
      AppLogger.i('getCachedData: loaded ${data.categories.length} categories, version ${data.version}');
      return data1;
    } catch (e, st) {
      AppLogger.e('getCachedData failed', e, st);
      return null;
    }
  }

  @override
  Future<WordZooData> getData() async {
    final cached = await getCachedData();
    if (cached != null) {
      AppLogger.i('getData: using cached data');
      bool needUpdate = await needsUpdate();
      if (needUpdate) {
        AppLogger.i('getData: data is outdated, syncing...');
        //await syncData();
      } else {
        return cached;
      }
    }

    AppLogger.i('getData: no cache found, syncing...');
    await syncData();

    final refreshed = await getCachedData();
    if (refreshed == null) {
      throw Exception('Không thể tải dữ liệu sau khi đồng bộ');
    }
    return refreshed;
  }

  @override
  Future<bool> needsUpdate() async {
    try {
      final box = Hive.box<String>('app_data');
      final localVersion = box.get(AppConstants.dataVersionKey);
      if (localVersion == null) return true;

      final response = await _client.from('data_versions').select().eq('is_active', true).order('created_at', ascending: false).limit(1).single();

      final remoteVersion = response['version'] as String;
      return remoteVersion != localVersion;
    } catch (e, st) {
      AppLogger.e('needsUpdate failed', e, st);
      return false;
    }
  }

  /*
  @override
  Future<void> syncData() async {
    try {
      final box = Hive.box<String>('app_data');

      final response = await _client.from('data_versions').select().eq('is_active', true).order('created_at', ascending: false).limit(1).single();
      final remoteVersion = response['version'] as String;
      final fileName = 'data-v$remoteVersion.json';
      AppLogger.i('Downloading data.json version $remoteVersion');
      final list = await _client.storage.listBuckets();
      final jsonUrl = await _client.storage.from(dataBucketName).getPublicUrl(fileName);
      print(Supabase.instance.client.storage.url);
      final response1 = await http.get(Uri.parse(jsonUrl));
      final jsonStr = response1.body;
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;

      if (json['version'] == null || json['categories'] == null) {
        throw Exception('Invalid data.json structure');
      }

      await box.put(AppConstants.dataJsonKey, jsonStr);
      await box.put(AppConstants.dataVersionKey, remoteVersion);

      AppLogger.i('Data synced successfully: version $remoteVersion');

      await syncCategoryZip(json);
      // Cache media files
      //await _cacheMediaFromJson(json);
    } catch (e, st) {
      AppLogger.e('syncData failed', e, st);
      rethrow;
    }
  }
*/

  @override
  Future<void> syncData() async {
    try {
      final box = Hive.box<String>('app_data');

      // ============================================================
      // 1. Lấy version từ Supabase DB
      // ============================================================

      final response = await _client.from('data_versions').select().eq('is_active', true).order('created_at', ascending: false).limit(1).single();

      final remoteVersion = response['version'] as String;

      final fileName = 'data-v$remoteVersion.json';

      AppLogger.i('Remote data version: $remoteVersion');

      // ============================================================
      // 2. Download data.json từ R2
      // ============================================================

      AppLogger.i('Downloading $fileName from R2...');

      final file = await R2RepositoryImplement.instance.downloadFile(fileName, localFileName: fileName);

      // ============================================================
      // 3. Đọc JSON từ file
      // ============================================================

      if (!await file.exists()) {
        throw Exception('Downloaded file does not exist: $fileName');
      }

      final jsonStr = await file.readAsString();

      if (jsonStr.isEmpty) {
        throw Exception('Downloaded data file is empty: $fileName');
      }

      // ============================================================
      // 4. Parse JSON
      // ============================================================

      final json = jsonDecode(jsonStr) as Map<String, dynamic>;

      if (json['version'] == null || json['categories'] == null) {
        throw Exception('Invalid data.json structure');
      }

      // ============================================================
      // 5. Kiểm tra version
      // ============================================================

      final dataVersion = json['version'].toString();

      if (dataVersion != remoteVersion) {
        throw Exception(
          'Version mismatch: '
          'DB=$remoteVersion, '
          'JSON=$dataVersion',
        );
      }

      // ============================================================
      // 6. Cache data.json vào Hive
      // ============================================================

      await box.put(AppConstants.dataJsonKey, jsonStr);

      await box.put(AppConstants.dataVersionKey, remoteVersion);

      AppLogger.i(
        'Data synced successfully: '
        'version $remoteVersion',
      );

      // ============================================================
      // 7. Download ZIP từ R2
      // ============================================================

      await syncCategoryZip(json);
    } catch (e, st) {
      AppLogger.e('syncData failed', e, st);

      rethrow;
    }
  }

  Future<void> _cacheMediaFromJson(Map<String, dynamic> json) async {
    try {
      final categories = json['categories'] as List<dynamic>;
      final imagePaths = <String>{};
      final audioPaths = <String>{};

      for (final category in categories) {
        // Category-level media
        await MediaCacheService.instance.downloadAndCacheBatch([category['id'] as String], MediaType.folder);

        final icon = category['real_image'] as String?;
        final background = category['real_image'] as String?;
        final localizedNamesAudio = category['audio'] as Map<String, dynamic>?;

        if (icon != null && icon.isNotEmpty) imagePaths.add(icon);
        if (background != null && background.isNotEmpty) imagePaths.add(background);
        if (localizedNamesAudio != null) {
          for (final p in localizedNamesAudio.values) {
            if (p != null && p is String && p.isNotEmpty) audioPaths.add(p);
          }
        }

        // Subcategory-level media
        final subcategories = category['subcategories'] as List<dynamic>?;
        if (subcategories != null) {
          for (final sub in subcategories) {
            final subIcon = sub['icon'] as String?;
            final subBackground = sub['real_image'] as String?;
            final subLocalizedNamesAudio = sub['audio'] as Map<String, dynamic>?;

            if (subIcon != null && subIcon.isNotEmpty) imagePaths.add(subIcon);
            if (subBackground != null && subBackground.isNotEmpty) imagePaths.add(subBackground);
            if (subLocalizedNamesAudio != null) {
              for (final p in subLocalizedNamesAudio.values) {
                if (p != null && p is String && p.isNotEmpty) audioPaths.add(p);
              }
            }

            // Entity-level media
            final entities = sub['entities'] as List<dynamic>?;
            if (entities != null) {
              for (final entity in entities) {
                if (entity is Map<String, dynamic>) {
                  final realImage = entity['real_image'] as String?;
                  final animationImage = entity['animation_image'] as String?;
                  final audioNames = entity['audio'] as Map<String, dynamic>?;
                  final soundEffect = entity['animal_sound'] as String?;

                  if (realImage != null && realImage.isNotEmpty) imagePaths.add(realImage);
                  if (animationImage != null && animationImage.isNotEmpty) imagePaths.add(animationImage);
                  if (audioNames != null) {
                    for (final p in audioNames.values) {
                      if (p != null && p is String && p.isNotEmpty) audioPaths.add(p);
                    }
                  }
                  if (soundEffect != null && soundEffect.isNotEmpty) audioPaths.add(soundEffect);
                }
              }
            }
          }
        }
      }

      AppLogger.i('Caching ${imagePaths.length} images and ${audioPaths.length} audio files...');
      await MediaCacheService.instance.downloadAndCacheBatch(imagePaths.toList(), MediaType.image);
      await MediaCacheService.instance.downloadAndCacheBatch(audioPaths.toList(), MediaType.audio);
      AppLogger.i('Media caching completed');
    } catch (e, st) {
      AppLogger.e('_cacheMediaFromJson failed', e, st);
      // Don't throw - media caching is optional
    }
  }

  @override
  Future<Map<String, String>> getLocalMediaPaths() async {
    final cached = await getCachedData();
    if (cached == null) {
      return {};
    }

    final paths = <String, String>{};
    final allEntities = <Map<String, dynamic>>[];

    for (final category in cached.categories) {
      for (final sub in category.subcategories) {
        for (final entity in sub.entities) {
          final entityJson = entity.toJson();
          allEntities.add(entityJson);
        }
      }
    }

    return await MediaCacheService.instance.cacheEntities(allEntities);
  }

  @override
  Future<void> precacheAssets() async {
    AppLogger.i('precacheAssets: starting media pre-caching...');
    try {
      await getLocalMediaPaths();
      AppLogger.i('precacheAssets: completed');
    } catch (e, st) {
      AppLogger.e('precacheAssets failed', e, st);
    }
  }

  Future<String?> getLocalImagePath(String remotePath) async {
    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/wordzoo/$remotePath');

    if (await file.exists()) {
      return file.path;
    }

    return null;
  }

  Future<String?> getLocalAudioPath(String remotePath) async {
    try {
      final file = await MediaCacheService.instance.getLocalFile(remotePath, MediaType.audio);
      if (await file.exists()) {
        return file.path;
      }
      return null;
    } catch (e, st) {
      AppLogger.e('getLocalAudioPath failed', e, st);
      return null;
    }
  }

  Future<void> syncCategoryZip(Map<String, dynamic> json) async {
    final zipFiles = json['zip_files'] as Map<String, dynamic>?;

    if (zipFiles == null || zipFiles.isEmpty) {
      return;
    }

    int completedCategories = 0;
    final totalCategories = zipFiles.length;

    DataManager().downloadProgressModel.notiDownloadProgress(0, true);

    for (final item in zipFiles.entries) {
      final categoryId = item.key;

      final List<String> zipNames = (item.value as List).map((e) => e.toString()).toList();

      print(
        'Downloading category: $categoryId '
        '(${zipNames.length} parts)',
      );

      // Download + extract toàn bộ ZIP của category
      for (int i = 0; i < zipNames.length; i++) {
        final zipName = zipNames[i];

        print(
          '  [$categoryId] '
          '${i + 1}/${zipNames.length}: $zipName',
        );

        await ZipAssetService.instance.downloadAndExtractCategoryZip(categoryId, zipName);
      }

      completedCategories++;

      final progress = (completedCategories * 100 / totalCategories).toInt();

      DataManager().downloadProgressModel.notiDownloadProgress(progress, true);

      print(
        '✓ Category $categoryId completed '
        '($progress%)',
      );
    }

    DataManager().downloadProgressModel.notiDownloadProgress(100, true);

    Future.delayed(const Duration(seconds: 1), () {
      DataManager().downloadProgressModel.notiDownloadProgress(100, false);
    });
  }

  /*  Future<void> syncCategoryZip(Map<String, dynamic> json) async {
    final zipFiles = json['zip_files'] as Map<String, dynamic>?;

    if (zipFiles == null) {
      return;
    }

    int index = 0;
    DataManager().downloadProgressModel.notiDownloadProgress((0).toInt(), true);
    for (final item in zipFiles.entries) {
      final categoryId = item.key;
      final String zipName = item.value as String;
      await ZipAssetService.instance.downloadAndExtractCategoryZip(categoryId, zipName);
      index++;
      DataManager().downloadProgressModel.notiDownloadProgress((index * 100 / zipFiles.length).toInt(), true);
      if (index == zipFiles.length) {
        DataManager().downloadProgressModel.notiDownloadProgress(100, true);
        Future.delayed(const Duration(seconds: 1), () {
          DataManager().downloadProgressModel.notiDownloadProgress(100, false);
        });
      }
    }
  }*/
}
