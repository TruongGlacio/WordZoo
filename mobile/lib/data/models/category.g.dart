// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => $checkedCreate('Category', json, ($checkedConvert) {
  $checkKeys(json,
      allowedKeys: const ['id', 'type', 'names', 'icon', 'audio', 'background', 'real_image', 'signpost_style', 'subcategories','pronunciation', 'visual_description']);
  String icon = $checkedConvert('real_image', (v) => (v ?? "") as String);
  String background = $checkedConvert('real_image', (v) => (v ?? "") as String);
  CategoryType type = $checkedConvert('type', (v) => $enumDecode(_$CategoryTypeEnumMap, v));
  switch (type) {
    case CategoryType.animals:
      // TODO: Handle this case.
      icon = Assets.assets.categoryCard.animalCard2.path;
      background = Assets.assets.background.animalsCategoryMap2k.path;
      break;
    case CategoryType.plants:
      // TODO: Handle this case.
      icon = Assets.assets.categoryCard.plantCard2.path;
      background = Assets.assets.background.plantsCategoryMap2k.path;
      break;
    case CategoryType.vehicles:
      // TODO: Handle this case.
      icon = Assets.assets.categoryCard.vehicleCard2.path;
      background = Assets.assets.background.vehiclesCategoryMap2k.path;
      break;
    case CategoryType.humanrelations:
      // TODO: Handle this case.
      icon = Assets.assets.categoryCard.humanRelationsCard2.path;
      background = Assets.assets.background.peopleCategoryMap2k.path;
      break;
    case CategoryType.basics:
      // TODO: Handle this case.
      icon = Assets.assets.categoryCard.animalCard2.path;
      background = Assets.assets.background.animalsCategoryMap2k.path;
      break;
  }
  final val = Category(
    id: $checkedConvert('id', (v) => v as String),
    type: $checkedConvert('type', (v) => $enumDecode(_$CategoryTypeEnumMap, v)),
    names: $checkedConvert('names', (v) => LocalizedNames.fromJson(v as Map<String, dynamic>)),
    audio: $checkedConvert('audio', (v) => AudioPaths.fromJson(v as Map<String, dynamic>)),
    icon: icon,
    pronunciationInfo: $checkedConvert('pronunciation', (v) => v == null ? null : PronunciationInfo.fromJson(v as Map<String, dynamic>)),
    background: background,
    signpostStyle: $checkedConvert('signpost_style', (v) => v as String?),
    subcategories: $checkedConvert('subcategories', (v) => (v as List<dynamic>).map((e) => Subcategory.fromJson(e as Map<String, dynamic>)).toList()),
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
  'audio': instance.audio?.toJson(),
  'pronunciation':instance.pronunciationInfo?.toJson()
};

const _$CategoryTypeEnumMap =
{
  CategoryType.animals: 'animals',
  CategoryType.plants: 'plants',
  CategoryType.vehicles: 'vehicles',
  CategoryType.humanrelations: 'human_relations',
  CategoryType.basics: 'basics',

};
