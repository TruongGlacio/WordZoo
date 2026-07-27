import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'audio_paths.g.dart';

@JsonSerializable()
class AudioPaths extends Equatable {
  final String vi;
  final String en;
  final String zh;

  const AudioPaths({
    required this.vi,
    required this.en,
    required this.zh,
  });

  factory AudioPaths.fromJson(Map<String, dynamic> json) =>
      _$AudioPathsFromJson(json);
  Map<String, dynamic> toJson() => _$AudioPathsToJson(this);

  @override
  List<Object?> get props => [vi, en, zh];
}
