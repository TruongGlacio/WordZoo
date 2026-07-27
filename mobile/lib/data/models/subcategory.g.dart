// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subcategory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subcategory _$SubcategoryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Subcategory', json, ($checkedConvert) {
      $checkKeys(json, allowedKeys: const ['id', 'order', 'names', 'entities']);
      final val = Subcategory(
        id: $checkedConvert('id', (v) => v as String),
        order: $checkedConvert('order', (v) => (v as num).toInt()),
        names: $checkedConvert(
          'names',
          (v) => LocalizedNames.fromJson(v as Map<String, dynamic>),
        ),
        entities: $checkedConvert(
          'entities',
          (v) => (v as List<dynamic>)
              .map((e) => Entity.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$SubcategoryToJson(Subcategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order': instance.order,
      'names': instance.names.toJson(),
      'entities': instance.entities.map((e) => e.toJson()).toList(),
    };
