// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => $checkedCreate(
  'UserProfile',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      allowedKeys: const [
        'id',
        'email',
        'display_name',
        'preferred_language',
        'avatar_url',
        'is_guest',
        'device_id',
        'is_premium',
        'created_at',
        'updated_at',
      ],
    );
    final val = UserProfile(
      id: $checkedConvert('id', (v) => v as String),
      email: $checkedConvert('email', (v) => v as String),
      displayName: $checkedConvert('display_name', (v) => v as String?),
      preferredLanguage: $checkedConvert(
        'preferred_language',
        (v) => v as String? ?? 'vi',
      ),
      avatarUrl: $checkedConvert('avatar_url', (v) => v as String?),
      isGuest: $checkedConvert('is_guest', (v) => v as bool? ?? false),
      deviceId: $checkedConvert('device_id', (v) => v as String?),
      isPremium: $checkedConvert('is_premium', (v) => v as bool? ?? false),
      createdAt: $checkedConvert('created_at', (v) => v as String),
      updatedAt: $checkedConvert('updated_at', (v) => v as String),
    );
    return val;
  },
  fieldKeyMap: const {
    'displayName': 'display_name',
    'preferredLanguage': 'preferred_language',
    'avatarUrl': 'avatar_url',
    'isGuest': 'is_guest',
    'deviceId': 'device_id',
    'isPremium': 'is_premium',
    'createdAt': 'created_at',
    'updatedAt': 'updated_at',
  },
);

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'display_name': instance.displayName,
      'preferred_language': instance.preferredLanguage,
      'avatar_url': instance.avatarUrl,
      'is_guest': instance.isGuest,
      'device_id': instance.deviceId,
      'is_premium': instance.isPremium,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
