import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'subcategory.dart';
import 'localized_names.dart';
import 'package:wordzoo/utils/media_cache_service.dart';

part 'category.g.dart';

enum CategoryType { animals, plants, vehicles, humanRelations }

@JsonSerializable(explicitToJson: true)
class Category extends Equatable {
  final String id;
  final CategoryType type;
  final LocalizedNames names;
  final String icon;
  final String background;
  @JsonKey(name: 'signpost_style')
  final String signpostStyle;
  final List<Subcategory> subcategories;

  const Category({
    required this.id,
    required this.type,
    required this.names,
    required this.icon,
    required this.background,
    required this.signpostStyle,
    required this.subcategories,
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  String getName(String lang) => names.getBy(lang);

  Future<String?> getLocalIcon() async {
    return MediaCacheService.instance.getLocalPathIfExists(icon, MediaType.image);
  }

  Future<String?> getLocalBackground() async {
    return MediaCacheService.instance.getLocalPathIfExists(background, MediaType.image);
  }

  @override
  List<Object?> get props => [id, type, names, subcategories];
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