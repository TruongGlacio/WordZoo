// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Entity _$EntityFromJson(Map<String, dynamic> json) => $checkedCreate(
  'Entity',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      allowedKeys: const [
        'id',
        'is_premium',
        'names',
        'animation_image',
        'real_image',
        'sound_effect',
        'type_tags',
        'difficulty',
        'audio',
        'animal_sound',
        'pronunciation'
      ],
    );
    final val = Entity(
      id: $checkedConvert('id', (v) => v as String),
      isPremium: $checkedConvert('is_premium', (v) =>( v??false) as bool?),
      names: $checkedConvert(
        'names',
        (v) => LocalizedNames.fromJson(v as Map<String, dynamic>),
      ),
      animationImage: $checkedConvert('animation_image', (v) => (v??"") as String),
      realImage: $checkedConvert('real_image', (v) => (v??"") as String),
      audio: $checkedConvert('audio', (v) => AudioPaths.fromJson((v??{}) as Map<String, dynamic>),),
      soundEffect: $checkedConvert('animal_sound', (v) => (v??"") as String?),
      typeTags: $checkedConvert('type_tags', (v) => ((v??[]) as List<dynamic>).map((e) => (e??"") as String).toList(),),
      difficulty: $checkedConvert('difficulty', (v) => ((v??0) as num).toInt()),
      pronunciationInfo: $checkedConvert('pronunciation', (v) => v == null ? null : PronunciationInfo.fromJson(v as Map<String, dynamic>)),
    );
    return val;
  },
  fieldKeyMap: const {
    'isPremium': 'is_premium',
    'animationImage': 'animation_image',
    'realImage': 'real_image',
    'audioNames': 'audio_names',
    'soundEffect': 'sound_effect',
    'typeTags': 'type_tags',
  },
);

Map<String, dynamic> _$EntityToJson(Entity instance) => <String, dynamic>{
  'id': instance.id,
  'is_premium': instance.isPremium,
  'names': instance.names.toJson(),
  'animation_image': instance.animationImage,
  'real_image': instance.realImage,
  'audio_names': instance.audio?.toJson(),
  'sound_effect': instance.soundEffect,
  'type_tags': instance.typeTags,
  'difficulty': instance.difficulty,
  'pronunciation': instance.pronunciationInfo?.toJson()
};
