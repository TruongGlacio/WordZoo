import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'entity.dart';
import 'localized_names.dart';

part 'subcategory.g.dart';

@JsonSerializable(explicitToJson: true)
class Subcategory extends Equatable {
  final String id;
  final int order;
  final String icon;
  Offset? position;
  final LocalizedNames names;
  final List<Entity> entities;

  Subcategory({
    required this.id,
    required this.order,
    required this.icon,
    required this.names,
    required this.entities,
    this.position
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) =>
      _$SubcategoryFromJson(json);
  Map<String, dynamic> toJson() => _$SubcategoryToJson(this);

  @override
  List<Object?> get props => [id, order, names, entities];
}
