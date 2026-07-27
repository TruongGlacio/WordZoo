part of 'progress_bloc.dart';

sealed class ProgressEvent extends Equatable {
  const ProgressEvent();
  @override
  List<Object?> get props => [];
}

class LoadProgress extends ProgressEvent {
  const LoadProgress();
}

class UpdateProgress extends ProgressEvent {
  final String entityId;
  final bool isLearned;
  final bool isFavorite;
  const UpdateProgress({
    required this.entityId,
    required this.isLearned,
    required this.isFavorite,
  });
  @override
  List<Object?> get props => [entityId, isLearned, isFavorite];
}
