import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'localized_names.dart';
import 'audio_paths.dart';

part 'entity.g.dart';

@JsonSerializable(explicitToJson: true)
class Entity extends Equatable {
  final String id;
  final bool isPremium;
  final LocalizedNames names;
  @JsonKey(name: 'animation_image')
  final String animationImage;
  @JsonKey(name: 'real_image')
  final String realImage;
  @JsonKey(name: 'audio_names')
  final AudioPaths audioNames;
  @JsonKey(name: 'sound_effect')
  final String? soundEffect;
  @JsonKey(name: 'type_tags')
  final List<String> typeTags;
  final int difficulty;

  const Entity({
    required this.id,
    required this.isPremium,
    required this.names,
    required this.animationImage,
    required this.realImage,
    required this.audioNames,
    this.soundEffect,
    required this.typeTags,
    required this.difficulty,
  });

  factory Entity.fromJson(Map<String, dynamic> json) => _$EntityFromJson(json);
  Map<String, dynamic> toJson() => _$EntityToJson(this);

  @override
  List<Object?> get props => [
    id,
    isPremium,
    names,
    animationImage,
    realImage,
    audioNames,
    soundEffect,
    typeTags,
    difficulty,
  ];
}
