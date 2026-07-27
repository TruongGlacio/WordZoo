import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'localized_names.g.dart';

@JsonSerializable()
class LocalizedNames extends Equatable {
  final String vi;
  final String en;
  final String zh;

  const LocalizedNames({
    required this.vi,
    required this.en,
    required this.zh,
  });

  factory LocalizedNames.fromJson(Map<String, dynamic> json) =>
      _$LocalizedNamesFromJson(json);
  Map<String, dynamic> toJson() => _$LocalizedNamesToJson(this);

  String getBy(String lang) {
    switch (lang) {
      case 'en':
        return en;
      case 'zh':
        return zh;
      case 'vi':
      default:
        return vi;
    }
  }

  @override
  List<Object?> get props => [vi, en, zh];
}
