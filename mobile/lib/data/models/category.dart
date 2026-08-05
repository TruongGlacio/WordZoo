import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wordzoo/data/datasources/data_manager.dart';
import 'audio_paths.dart';
import 'subcategory.dart';
import 'localized_names.dart';
import 'package:wordzoo/utils/media_cache_service.dart';
import 'package:wordzoo/generated/assets.dart';

part 'category.g.dart';

enum CategoryType { animals, plants, vehicles, humanrelations,basics  }

@JsonSerializable(explicitToJson: true)
class Category extends Equatable {
  final String id;
  final CategoryType type;
  final LocalizedNames names;
  final String icon;
  final String background;
  @JsonKey(name: 'signpost_style')
  final String? signpostStyle;
  final List<Subcategory> subcategories;
  AudioPaths? audio;
  PronunciationInfo? pronunciationInfo;

   Category({
    required this.id,
    required this.type,
    required this.names,
    required this.icon,
    required this.background,
     this.signpostStyle,
    required this.subcategories,
     this.audio,
     this.pronunciationInfo
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  String getName(String lang) => names.getBy(lang);

  String getLocalIconPath()  {
    return DataManager().getRootPath()+ icon;
  }

  String getLocalBackground()  {
    return DataManager().getRootPath()+ background;
  }

  @override
  List<Object?> get props => [id, type, names, subcategories, audio, pronunciationInfo];
}

class CategoryLayout {
  final Subcategory category;
  final Offset position;
   double? rotation;
   double? scale;
   CategoryLayout({
    required this.category,
    required this.position,
    this.rotation = 0,
    this.scale=1
  });
}