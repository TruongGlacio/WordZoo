// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_zoo_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordZooData _$WordZooDataFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WordZooData', json, ($checkedConvert) {
      $checkKeys(
        json,
        allowedKeys: const ['version', 'last_updated', 'categories'],
      );
      final val = WordZooData(
        version: $checkedConvert('version', (v) => v as String),
        lastUpdated: $checkedConvert(
          'last_updated',
          (v) => DateTime.parse(v as String),
        ),
        categories: $checkedConvert(
          'categories',
          (v) => (v as List<dynamic>)
              .map((e) => Category.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    }, fieldKeyMap: const {'lastUpdated': 'last_updated'});

Map<String, dynamic> _$WordZooDataToJson(WordZooData instance) =>
    <String, dynamic>{
      'version': instance.version,
      'last_updated': instance.lastUpdated.toIso8601String(),
      'categories': instance.categories.map((e) => e.toJson()).toList(),
    };
