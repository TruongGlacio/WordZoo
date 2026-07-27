import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/progress_repository.dart';

part 'progress_event.dart';
part 'progress_state.dart';

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  final ProgressRepository progressRepo;

  ProgressBloc({required this.progressRepo}) : super(const ProgressInitial()) {
    on<LoadProgress>(_onLoadProgress);
    on<UpdateProgress>(_onUpdateProgress);
  }

  Future<void> _onLoadProgress(
    LoadProgress event,
    Emitter<ProgressState> emit,
  ) async {
    emit(const ProgressLoading());
    try {
      // TODO: get userId from auth state
      final userId = 'guest';
      final learned = await progressRepo.getLearnedEntities(userId);
      final favorites = await progressRepo.getFavoriteEntities(userId);
      emit(ProgressLoaded(
        learnedEntities: learned,
        favoriteEntities: favorites,
      ));
    } catch (e) {
      emit(ProgressError(e.toString()));
    }
  }

  Future<void> _onUpdateProgress(
    UpdateProgress event,
    Emitter<ProgressState> emit,
  ) async {
    try {
      // TODO: get userId from auth state
      final userId = 'guest';
      if (event.isLearned) {
        await progressRepo.markAsLearned(userId, event.entityId);
      } else {
        await progressRepo.toggleFavorite(userId, event.entityId, event.isFavorite);
      }
      // Reload
      add(const LoadProgress());
    } catch (e) {
      emit(ProgressError(e.toString()));
    }
  }
}
