import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/word_zoo_data.dart';
import 'package:wordzoo/utils/constants.dart';
import 'package:wordzoo/utils/logger.dart';

abstract class DataSyncRepository {
  Future<WordZooData?> getCachedData();
  Future<void> syncData();
  Future<bool> needsUpdate();
  Future<void> precacheAssets();
}

class DataSyncRepositoryImpl implements DataSyncRepository {
  DataSyncRepositoryImpl._internal();
  static final DataSyncRepositoryImpl _instance = DataSyncRepositoryImpl._internal();
  static DataSyncRepositoryImpl get instance => _instance;
  factory DataSyncRepositoryImpl() => _instance;

  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<WordZooData?> getCachedData() async {
    try {
      final box = Hive.box<String>('app_data');
      final jsonStr = box.get(AppConstants.dataJsonKey);
      if (jsonStr == null) return null;

      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      return WordZooData.fromJson(json);
    } catch (e, st) {
      AppLogger.e('getCachedData failed', e, st);
      return null;
    }
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
          .from('data')
          .download('data-v$remoteVersion.json');

      final jsonStr = utf8.decode(bytes);
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;

      if (json['version'] == null || json['categories'] == null) {
        throw Exception('Invalid data.json structure');
      }

      await box.put(AppConstants.dataJsonKey, jsonStr);
      await box.put(AppConstants.dataVersionKey, remoteVersion);

      AppLogger.i('Data synced successfully: version $remoteVersion');
    } catch (e, st) {
      AppLogger.e('syncData failed', e, st);
      rethrow;
    }
  }

  @override
  Future<void> precacheAssets() async {
    AppLogger.i('precacheAssets: placeholder for asset preloading');
  }
}
