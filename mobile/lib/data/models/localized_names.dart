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
class PronunciationInfo {
  IpaInfo? en;
  IpaInfo? zh;

  PronunciationInfo({this.en, this.zh});

  PronunciationInfo.fromJson(Map<String, dynamic> json) {
    en = json['en'] != null ? IpaInfo.fromJson(json['en']) : null;
    zh = json['zh'] != null ? IpaInfo.fromJson(json['zh']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.en != null) {
      data['en'] = en!.toJson();
    }
    if (this.zh != null) {
      data['zh'] = zh!.toJson();
    }
    return data;
  }
  IpaInfo? getBy(String lang) {
    switch (lang) {
      case 'en':
        return en;
      case 'zh':
        return zh;
      case 'vi':
      default:
        return null;
    }
  }
}

class IpaInfo {
  String? ipa;
  String? syllable;

  IpaInfo({this.ipa, this.syllable});

  IpaInfo.fromJson(Map<String, dynamic> json) {
    ipa = json['ipa'];
    syllable = json['syllable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ipa'] = this.ipa;
    data['syllable'] = this.syllable;
    return data;
  }
}

