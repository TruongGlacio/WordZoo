import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_progress.g.dart';

@JsonSerializable()
class UserProgress extends Equatable {
  final int? id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'entity_id')
  final String entityId;
  @JsonKey(name: 'category_type')
  final String categoryType;
  @JsonKey(name: 'subcategory_id')
  final String subcategoryId;
  @JsonKey(name: 'is_learned')
  final bool isLearned;
  @JsonKey(name: 'is_favorite')
  final bool isFavorite;
  @JsonKey(name: 'last_practiced_at')
  final String? lastPracticedAt;
  final String createdAt;
  final String updatedAt;

  const UserProgress({
    this.id,
    required this.userId,
    required this.entityId,
    required this.categoryType,
    required this.subcategoryId,
    required this.isLearned,
    required this.isFavorite,
    this.lastPracticedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) =>
      _$UserProgressFromJson(json);
  Map<String, dynamic> toJson() => _$UserProgressToJson(this);

  UserProgress copyWith({
    int? id,
    String? userId,
    String? entityId,
    String? categoryType,
    String? subcategoryId,
    bool? isLearned,
    bool? isFavorite,
    String? lastPracticedAt,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserProgress(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      entityId: entityId ?? this.entityId,
      categoryType: categoryType ?? this.categoryType,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      isLearned: isLearned ?? this.isLearned,
      isFavorite: isFavorite ?? this.isFavorite,
      lastPracticedAt: lastPracticedAt ?? this.lastPracticedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    entityId,
    categoryType,
    subcategoryId,
    isLearned,
    isFavorite,
    lastPracticedAt,
    createdAt,
    updatedAt,
  ];
}
