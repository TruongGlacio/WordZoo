import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'category.dart';

part 'word_zoo_data.g.dart';

@JsonSerializable(explicitToJson: true)
class WordZooData extends Equatable {
  final String version;
  @JsonKey(name: 'last_updated')
  final DateTime lastUpdated;
  final List<Category> categories;

  const WordZooData({
    required this.version,
    required this.lastUpdated,
    required this.categories,
  });

  factory WordZooData.fromJson(Map<String, dynamic> json) =>
      _$WordZooDataFromJson(json);
  Map<String, dynamic> toJson() => _$WordZooDataToJson(this);

  @override
  List<Object?> get props => [version, lastUpdated, categories];
}
