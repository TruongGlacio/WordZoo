import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  @JsonKey(defaultValue: 'vi')
  final String preferredLanguage;
  final String? avatarUrl;
  @JsonKey(defaultValue: false)
  final bool isGuest;
  final String? deviceId;
  @JsonKey(defaultValue: false)
  final bool isPremium;
  final String createdAt;
  final String updatedAt;

  const UserProfile({
    required this.id,
    required this.email,
    this.displayName,
    required this.preferredLanguage,
    this.avatarUrl,
    required this.isGuest,
    this.deviceId,
    required this.isPremium,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);

  @override
  List<Object?> get props => [
    id,
    email,
    displayName,
    preferredLanguage,
    avatarUrl,
    isGuest,
    deviceId,
    isPremium,
    createdAt,
    updatedAt,
  ];
}
