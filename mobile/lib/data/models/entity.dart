import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wordzoo/data/datasources/data_manager.dart';
import 'package:wordzoo/utils/premium_entity_manager.dart';
import 'category.dart';
import 'localized_names.dart';
import 'audio_paths.dart';
import 'package:wordzoo/utils/media_cache_service.dart';

part 'entity.g.dart';

@JsonSerializable(explicitToJson: true)
class Entity extends Equatable {
  final String id;
  bool ?isPremium;
  final LocalizedNames names;
  @JsonKey(name: 'animation_image')
  final String ?animationImage;
  @JsonKey(name: 'real_image')
  final String ?realImage;
  @JsonKey(name: 'sound_effect')
  final String? soundEffect;
  @JsonKey(name: 'type_tags')
  final List<String> ?typeTags;
  final int ?difficulty;
  AudioPaths? audio;
  PronunciationInfo? pronunciationInfo;

  Entity({
    required this.id,
    required this.isPremium,
    required this.names,
    required this.animationImage,
    required this.realImage,
    this.soundEffect,
    required this.typeTags,
    required this.difficulty,
    this.audio,
    this.pronunciationInfo
  });

  factory Entity.fromJson(Map<String, dynamic> json) => _$EntityFromJson(json);
  Map<String, dynamic> toJson() => _$EntityToJson(this);

  String getName(String lang) => names.getBy(lang)??'';

  Future<String?> getLocalRealImage() async {
    return MediaCacheService.instance.getLocalPathIfExists(realImage??"", MediaType.image);
  }

  Future<String?> getLocalAnimationImage() async {
    return MediaCacheService.instance.getLocalPathIfExists(animationImage??"", MediaType.image);
  }
  String getLocalIcon() {
      return DataManager().getRootPath()+ (realImage??'');
  }

  bool isOpenedEntity(){
    bool isOpen = true;
    if(isPremium == false)
      {
        isOpen = true;
      }
    else
      {
        isOpen = PremiumEntityManager().checkOpenedEntity(entity: this);
      }
    return isOpen;
  }
  String? getLocalAudio(String lang) {
    final path = lang == 'vi'
        ? audio?.vi
        : lang == 'en'
            ? audio?.en
            : audio?.zh;
    if((path??'').isNotEmpty) {
      return DataManager().getRootPath()+ (path??'');
    }
    return null;
  }

  String? getLocalSoundEffect() {
    if (soundEffect == null) {
      return null;
    }
    return DataManager().getRootPath()+ soundEffect!;
  }

  @override
  List<Object?> get props => [
    id,
    isPremium,
    names,
    animationImage,
    realImage,
    audio,
    soundEffect,
    typeTags,
    difficulty,
  ];
}
