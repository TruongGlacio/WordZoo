import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wordzoo/data/datasources/data_manager.dart';
import 'audio_paths.dart';
import 'category.dart';
import 'entity.dart';
import 'localized_names.dart';
import 'package:wordzoo/utils/media_cache_service.dart';

part 'subcategory.g.dart';

@JsonSerializable(explicitToJson: true)
class Subcategory extends Equatable {
  final String id;
  final int? order;
  final String icon;
  Offset? position;
  final LocalizedNames names;
  final List<Entity> entities;
  AudioPaths? audio;
  PronunciationInfo? pronunciationInfo;
  Subcategory({
    required this.id,
    this.order,
    required this.icon,
    required this.names,
    required this.entities,
    this.position,
    this.audio,
    this.pronunciationInfo
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) =>
      _$SubcategoryFromJson(json);
  Map<String, dynamic> toJson() => _$SubcategoryToJson(this);

  String getName(String lang) => names.getBy(lang);

  String getLocalIcon() {
    return DataManager().getRootPath()+ icon;
  }

  @override
  List<Object?> get props => [id, order, names, entities, audio, pronunciationInfo];
}
