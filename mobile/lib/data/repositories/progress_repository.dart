import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wordzoo/utils/logger.dart';

abstract class ProgressRepository {
  Future<void> markAsLearned(String userId, String entityId);
  Future<void> toggleFavorite(String userId, String entityId, bool isFavorite);
  Future<Map<String, bool>> getLearnedEntities(String userId);
  Future<Map<String, bool>> getFavoriteEntities(String userId);
  Future<void> syncPendingProgress();
}

class ProgressRepositoryImpl implements ProgressRepository {
  ProgressRepositoryImpl._internal();
  static final ProgressRepositoryImpl _instance = ProgressRepositoryImpl._internal();
  static ProgressRepositoryImpl get instance => _instance;
  factory ProgressRepositoryImpl() => _instance;

  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<void> markAsLearned(String userId, String entityId) async {
    try {
      final now = DateTime.now().toIso8601String();
      await _client.from('user_progress').upsert({
        'user_id': userId,
        'entity_id': entityId,
        'is_learned': true,
        'updated_at': now,
        'created_at': now,
      });
    } catch (e, st) {
      AppLogger.e('markAsLearned failed', e, st);
      rethrow;
    }
  }

  @override
  Future<void> toggleFavorite(String userId, String entityId, bool isFavorite) async {
    try {
      final now = DateTime.now().toIso8601String();
      await _client.from('user_progress').upsert({
        'user_id': userId,
        'entity_id': entityId,
        'is_favorite': isFavorite,
        'updated_at': now,
        'created_at': now,
      });
    } catch (e, st) {
      AppLogger.e('toggleFavorite failed', e, st);
      final box = Hive.box<String>('app_data');
      await box.put('fav_$entityId', '$isFavorite');
    }
  }

  @override
  Future<Map<String, bool>> getLearnedEntities(String userId) async {
    try {
      final response = await _client
          .from('user_progress')
          .select()
          .eq('user_id', userId)
          .eq('is_learned', true);

      final Map<String, bool> result = {};
      for (var item in response as List) {
        result[item['entity_id'] as String] = true;
      }
      return result;
    } catch (e, st) {
      AppLogger.e('getLearnedEntities failed', e, st);
      return {};
    }
  }

  @override
  Future<Map<String, bool>> getFavoriteEntities(String userId) async {
    try {
      final response = await _client
          .from('user_progress')
          .select()
          .eq('user_id', userId)
          .eq('is_favorite', true);

      final Map<String, bool> result = {};
      for (var item in response as List) {
        result[item['entity_id'] as String] = true;
      }
      return result;
    } catch (e, st) {
      AppLogger.e('getFavoriteEntities failed', e, st);
      return {};
    }
  }

  @override
  Future<void> syncPendingProgress() async {
    AppLogger.i('syncPendingProgress: placeholder for background sync');
  }
}
