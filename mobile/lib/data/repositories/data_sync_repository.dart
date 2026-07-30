import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/word_zoo_data.dart';
import 'package:wordzoo/utils/constants.dart';
import 'package:wordzoo/utils/logger.dart';
import 'package:wordzoo/utils/media_cache_service.dart';

abstract class DataSyncRepository {
  Future<WordZooData?> getCachedData();
  Future<void> syncData();
  Future<bool> needsUpdate();
  Future<void> precacheAssets();
  Future<WordZooData> getData();
  Future<Map<String, String>> getLocalMediaPaths();
}

class DataSyncRepositoryImpl implements DataSyncRepository {
  DataSyncRepositoryImpl._internal();
  static final DataSyncRepositoryImpl _instance = DataSyncRepositoryImpl._internal();
  static DataSyncRepositoryImpl get instance => _instance;
  factory DataSyncRepositoryImpl() => _instance;


  final SupabaseClient _client = Supabase.instance.client;
  final String dataBucketName= 'data';
  final String assetsBucketName= 'assets';
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
      AppLogger.i('getCachedData: loaded ${data.categories.length} categories, version ${data.version}');
      return data;
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
      return cached;
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

      final response = await _client
          .from('data_versions')
          .select()
          .eq('is_active', true)
          .single();

      final remoteVersion = response['version'] as String;
      return remoteVersion != localVersion;
    } catch (e, st) {
      AppLogger.e('needsUpdate failed', e, st);
      return false;
    }
  }

  @override
  Future<void> syncData() async {
    try {
      final box = Hive.box<String>('app_data');

      final response = await _client
          .from('data_versions')
          .select()
          .eq('is_active', true)
          .single();

      final remoteVersion = response['version'] as String;

      AppLogger.i('Downloading data.json version $remoteVersion');
      final bytes = await _client.storage
          .from(dataBucketName)
          .download('data-v$remoteVersion.json');

      final jsonStr = utf8.decode(bytes);
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;

      if (json['version'] == null || json['categories'] == null) {
        throw Exception('Invalid data.json structure');
      }

      await box.put(AppConstants.dataJsonKey, jsonStr);
      await box.put(AppConstants.dataVersionKey, remoteVersion);

      AppLogger.i('Data synced successfully: version $remoteVersion');

      // Cache media files
      await _cacheMediaFromJson(json);
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
        final icon = category['icon'] as String?;
        final background = category['background'] as String?;
        final localizedNamesAudio = category['localized_names_audio'] as Map<String, dynamic>?;

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
            final subBackground = sub['background'] as String?;
            final subLocalizedNamesAudio = sub['localized_names_audio'] as Map<String, dynamic>?;

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
                  final audioNames = entity['audio_names'] as Map<String, dynamic>?;
                  final soundEffect = entity['sound_effect'] as String?;

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
    try {
      final file = await MediaCacheService.instance.getLocalFile(remotePath, MediaType.image);
      if (await file.exists()) {
        return file.path;
      }
      return null;
    } catch (e, st) {
      AppLogger.e('getLocalImagePath failed', e, st);
      return null;
    }
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
}
