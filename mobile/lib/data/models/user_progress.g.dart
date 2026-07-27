// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProgress _$UserProgressFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'UserProgress',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const [
            'id',
            'user_id',
            'entity_id',
            'category_type',
            'subcategory_id',
            'is_learned',
            'is_favorite',
            'last_practiced_at',
            'created_at',
            'updated_at',
          ],
        );
        final val = UserProgress(
          id: $checkedConvert('id', (v) => (v as num?)?.toInt()),
          userId: $checkedConvert('user_id', (v) => v as String),
          entityId: $checkedConvert('entity_id', (v) => v as String),
          categoryType: $checkedConvert('category_type', (v) => v as String),
          subcategoryId: $checkedConvert('subcategory_id', (v) => v as String),
          isLearned: $checkedConvert('is_learned', (v) => v as bool),
          isFavorite: $checkedConvert('is_favorite', (v) => v as bool),
          lastPracticedAt: $checkedConvert(
            'last_practiced_at',
            (v) => v as String?,
          ),
          createdAt: $checkedConvert('created_at', (v) => v as String),
          updatedAt: $checkedConvert('updated_at', (v) => v as String),
        );
        return val;
      },
      fieldKeyMap: const {
        'userId': 'user_id',
        'entityId': 'entity_id',
        'categoryType': 'category_type',
        'subcategoryId': 'subcategory_id',
        'isLearned': 'is_learned',
        'isFavorite': 'is_favorite',
        'lastPracticedAt': 'last_practiced_at',
        'createdAt': 'created_at',
        'updatedAt': 'updated_at',
      },
    );

Map<String, dynamic> _$UserProgressToJson(UserProgress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'entity_id': instance.entityId,
      'category_type': instance.categoryType,
      'subcategory_id': instance.subcategoryId,
      'is_learned': instance.isLearned,
      'is_favorite': instance.isFavorite,
      'last_practiced_at': instance.lastPracticedAt,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
