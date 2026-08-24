import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'localized_names.g.dart';

@JsonSerializable()
class LocalizedNames extends Equatable {
  final String vi;
  final String en;
  final String zh;
  final String? es;
  final String? fr;
  final String? ja;
  final String? ko;
  const LocalizedNames({
    required this.vi,
    required this.en,
    required this.zh,
    this.ko,
    this.ja,
    this.fr,
    this.es
  });

  factory LocalizedNames.fromJson(Map<String, dynamic> json) =>
      _$LocalizedNamesFromJson(json);
  Map<String, dynamic> toJson() => _$LocalizedNamesToJson(this);

  String? getBy(String lang) {
    switch (lang) {
      case 'en':
        return en;
      case 'zh':
        return zh;
      case 'vi':
        return vi;
      case 'es':
        return es;
      case 'fr':
        return fr;
      case 'ja':
        return ja;
      case 'ko':
        return ko;
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
  IpaInfo? vi;
  IpaInfo? es;
  IpaInfo? fr;
  IpaInfo? ja;
  IpaInfo? ko;
  PronunciationInfo({this.en, this.zh, this.vi, this.es, this.fr, this.ja, this.ko});

  PronunciationInfo.fromJson(Map<String, dynamic> json) {
    en = json['en'] != null ? IpaInfo.fromJson(json['en'] as Map<String, dynamic>) : null;
    zh = json['zh'] != null ? IpaInfo.fromJson(json['zh'] as Map<String, dynamic>) : null;
    vi = json['vi'] != null ? IpaInfo.fromJson(json['vi'] as Map<String, dynamic>) : null;
    es = json['es'] != null ? IpaInfo.fromJson(json['es'] as Map<String, dynamic>) : null;
    fr = json['fr'] != null ? IpaInfo.fromJson(json['fr'] as Map<String, dynamic>) : null;
    ja = json['ja'] != null ? IpaInfo.fromJson(json['ja'] as Map<String, dynamic>) : null;
    ko = json['ko'] != null ? IpaInfo.fromJson(json['ko'] as Map<String, dynamic>) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.en != null) {
      data['en'] = en!.toJson();
    }
    if (this.zh != null) {
      data['zh'] = zh!.toJson();
    }
    if (this.vi != null) {
      data['vi'] = vi!.toJson();
    }
    if (this.es != null) {
      data['es'] = es!.toJson();
    }
    if (this.fr != null) {
      data['fr'] = fr!.toJson();
    }
    if (this.ja != null) {
      data['ja'] = ja!.toJson();
    }
    if (this.ko != null) {
      data['ko'] = ko!.toJson();
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
        return vi;
      case 'es':
        return es;
      case 'fr':
        return fr;
      case 'ja':
        return ja;
      case 'ko':
        return ko;
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
    ipa = (json['ipa']??json['pinyin']) as String?;
    syllable = json['syllable'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ipa'] = this.ipa;
    data['syllable'] = this.syllable;
    return data;
  }
}

