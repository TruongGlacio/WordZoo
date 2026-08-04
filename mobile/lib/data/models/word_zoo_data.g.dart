// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_zoo_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WordZooData _$WordZooDataFromJson(Map<String, dynamic> json) =>
    $checkedCreate('WordZooData', json, ($checkedConvert) {
      $checkKeys(
        json,
        allowedKeys: const ['version', 'last_updated', 'categories', "zip_files", "zip_files_version"],
      );
      final val = WordZooData(
        version: $checkedConvert('version', (v) => v as String),
        lastUpdated: json['last_updated']!=null?$checkedConvert(
          'last_updated',
          (p0) {
            return DateTime.parse(p0 as String);
          },
        ):null,
        categories: $checkedConvert(
          'categories',
          (v) => (v as List<dynamic>)
              .map((e) => Category.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        zipFiles: $checkedConvert(
          'zip_files',
          (v) => v as Map<String, dynamic>,
        ),
        zipFilesVersion: $checkedConvert(
          'zip_files_version',
          (v) => v as Map<String, dynamic>,
        ),
      );
      return val;
    }, fieldKeyMap: const {'lastUpdated': 'last_updated'});

Map<String, dynamic> _$WordZooDataToJson(WordZooData instance) =>
    <String, dynamic>{
      'version': instance.version,
      'last_updated': instance.lastUpdated?.toIso8601String(),
      'categories': instance.categories.map((e) => e.toJson()).toList(),
      'zip_files': instance.zipFiles,
      'zip_files_version': instance.zipFilesVersion,
    };
