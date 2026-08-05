// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subcategory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subcategory _$SubcategoryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Subcategory', json, ($checkedConvert) {
      $checkKeys(json, allowedKeys: const ['id', 'order', 'names', 'entities','audio', 'real_image', 'pronunciation']);
      final val = Subcategory(
        id: $checkedConvert('id', (v) => v as String),
        order: $checkedConvert('order', (v) => ((v??0) as num).toInt()),
        icon: $checkedConvert('real_image', (v) => ((v??"") as String)),
        names: $checkedConvert(
          'names',
          (v) => LocalizedNames.fromJson((v??{}) as Map<String, dynamic>),
        ),
        audio: $checkedConvert(
          'audio',
              (v) => AudioPaths.fromJson((v??{}) as Map<String, dynamic>),
        ),
        entities: $checkedConvert(
          'entities',
          (v) => (v as List<dynamic>)
              .map((e) => Entity.fromJson((e??[]) as Map<String, dynamic>))
              .toList(),
        ),
        pronunciationInfo: $checkedConvert('pronunciation', (v) => v == null ? null : PronunciationInfo.fromJson(v as Map<String, dynamic>)),
      );
      return val;
    });

Map<String, dynamic> _$SubcategoryToJson(Subcategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order': instance.order,
      'icon':instance.icon,
      'names': instance.names.toJson(),
      'entities': instance.entities.map((e) => e.toJson()).toList(),
      'audio': instance.audio?.toJson(),
      'pronunciation': instance.pronunciationInfo?.toJson()
    };
