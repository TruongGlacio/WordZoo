// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_paths.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AudioPaths _$AudioPathsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AudioPaths', json, ($checkedConvert) {
      $checkKeys(json, allowedKeys: const ['vi', 'en', 'zh']);
      final val = AudioPaths(
        vi: $checkedConvert('vi', (v) => v as String),
        en: $checkedConvert('en', (v) => v as String),
        zh: $checkedConvert('zh', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AudioPathsToJson(AudioPaths instance) =>
    <String, dynamic>{'vi': instance.vi, 'en': instance.en, 'zh': instance.zh};
