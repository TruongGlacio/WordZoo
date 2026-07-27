part of 'progress_bloc.dart';

sealed class ProgressState extends Equatable {
  const ProgressState();
  @override
  List<Object?> get props => [];
}

class ProgressInitial extends ProgressState {
  const ProgressInitial();
}

class ProgressLoading extends ProgressState {
  const ProgressLoading();
}

class ProgressLoaded extends ProgressState {
  final Map<String, bool> learnedEntities;
  final Map<String, bool> favoriteEntities;
  const ProgressLoaded({
    required this.learnedEntities,
    required this.favoriteEntities,
  });

  ProgressLoaded copyWith({
    Map<String, bool>? learnedEntities,
    Map<String, bool>? favoriteEntities,
  }) {
    return ProgressLoaded(
      learnedEntities: learnedEntities ?? this.learnedEntities,
      favoriteEntities: favoriteEntities ?? this.favoriteEntities,
    );
  }

  @override
  List<Object?> get props => [learnedEntities, favoriteEntities];
}

class ProgressUpdated extends ProgressState {
  final int total;
  final int learned;
  const ProgressUpdated({required this.total, required this.learned});
  @override
  List<Object?> get props => [total, learned];
}

class ProgressError extends ProgressState {
  final String message;
  const ProgressError(this.message);
  @override
  List<Object?> get props => [message];
}
