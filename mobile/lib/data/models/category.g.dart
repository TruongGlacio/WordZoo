// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Category', json, ($checkedConvert) {
      $checkKeys(
        json,
        allowedKeys: const [
          'id',
          'type',
          'names',
          'icon',
          'background',
          'signpost_style',
          'subcategories',
        ],
      );
      final val = Category(
        id: $checkedConvert('id', (v) => v as String),
        type: $checkedConvert(
          'type',
          (v) => $enumDecode(_$CategoryTypeEnumMap, v),
        ),
        names: $checkedConvert(
          'names',
          (v) => LocalizedNames.fromJson(v as Map<String, dynamic>),
        ),
        icon: $checkedConvert('icon', (v) => v as String),
        background: $checkedConvert('background', (v) => v as String),
        signpostStyle: $checkedConvert('signpost_style', (v) => v as String),
        subcategories: $checkedConvert(
          'subcategories',
          (v) => (v as List<dynamic>)
              .map((e) => Subcategory.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    }, fieldKeyMap: const {'signpostStyle': 'signpost_style'});

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
  'id': instance.id,
  'type': _$CategoryTypeEnumMap[instance.type]!,
  'names': instance.names.toJson(),
  'icon': instance.icon,
  'background': instance.background,
  'signpost_style': instance.signpostStyle,
  'subcategories': instance.subcategories.map((e) => e.toJson()).toList(),
};

const _$CategoryTypeEnumMap = {
  CategoryType.animals: 'animals',
  CategoryType.plants: 'plants',
  CategoryType.vehicles: 'vehicles',
  CategoryType.humanRelations: 'humanRelations',
};
