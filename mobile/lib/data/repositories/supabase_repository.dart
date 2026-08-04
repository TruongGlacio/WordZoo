import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';
import 'package:wordzoo/utils/logger.dart';

abstract class SupabaseRepository {
  Future<UserProfile?> getCurrentUserProfile();
  Future<UserProfile> createGuestProfile();
  Future<void> updateProfile(UserProfile profile);
  Future<void> signUp(String email, String password, String displayName);
  Future<void> signIn(String email, String password);
  Future<void> signOut();
}

class SupabaseRepositoryImpl implements SupabaseRepository {
  SupabaseRepositoryImpl._internal();
  static final SupabaseRepositoryImpl _instance = SupabaseRepositoryImpl._internal();
  static SupabaseRepositoryImpl get instance => _instance;
  factory SupabaseRepositoryImpl() => _instance;

  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<UserProfile?> getCurrentUserProfile() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return null;

      final response = await _client
          .from('user_profiles')
          .select()
          .eq('id', user.id)
          .single();
      //AppLogger.e('response',response);

      return UserProfile.fromJson(response);
    } catch (e, st) {
      AppLogger.e('getCurrentUserProfile failed', e, st);
      return null;
    }
  }

  @override
  Future<UserProfile> createGuestProfile() async {
    try {
      final deviceId = 'guest_${DateTime.now().millisecondsSinceEpoch}';
      final response = await _client.from('user_profiles').insert({
        'email': null,
        'display_name': null,
        'preferred_language': 'vi',
        'is_guest': true,
        'device_id': deviceId,
        'is_premium': false,
      }).select().single();

      return UserProfile.fromJson(response);
    } catch (e, st) {
      AppLogger.e('createGuestProfile failed', e, st);
      rethrow;
    }
  }

  @override
  Future<void> updateProfile(UserProfile profile) async {
    try {
      await _client
          .from('user_profiles')
          .update(profile.toJson())
          .eq('id', profile.id);
    } catch (e, st) {
      AppLogger.e('updateProfile failed', e, st);
      rethrow;
    }
  }

  @override
  Future<void> signUp(String email, String password, String displayName) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': displayName},
      );

      final user = response.user;
      if (user != null) {
        await _client.from('user_profiles').insert({
          'id': user.id,
          'email': email,
          'display_name': displayName,
          'preferred_language': 'vi',
          'is_guest': false,
          'is_premium': false,
        });
      }
    } catch (e, st) {
      AppLogger.e('signUp failed', e, st);
      rethrow;
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e, st) {
      AppLogger.e('signIn failed', e, st);
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e, st) {
      AppLogger.e('signOut failed', e, st);
      rethrow;
    }
  }
}
