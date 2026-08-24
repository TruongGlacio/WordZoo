// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localized_names.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalizedNames _$LocalizedNamesFromJson(Map<String, dynamic> json) =>
    $checkedCreate('LocalizedNames', json, ($checkedConvert) {
      $checkKeys(json, allowedKeys: const ['vi', 'en', 'zh','es', 'fr', 'ja', 'ko']);
      final val = LocalizedNames(
        vi: $checkedConvert('vi', (v) => v as String),
        en: $checkedConvert('en', (v) => v as String),
        zh: $checkedConvert('zh', (v) => v as String),
        es: $checkedConvert('es', (v) => v as String?),
        fr: $checkedConvert('fr', (v) => v as String?),
        ja: $checkedConvert('ja', (v) => v as String?),
        ko: $checkedConvert('ko', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$LocalizedNamesToJson(LocalizedNames instance) =>
    <String, dynamic>{'vi': instance.vi, 'en': instance.en, 'zh': instance.zh,
      'es': instance.es, 'fr': instance.fr, 'ja': instance.ja,'ko': instance.ko,
    };
