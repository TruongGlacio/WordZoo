import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/entity.dart';
import '../../data/models/subcategory.dart';
import '../../data/repositories/data_sync_repository.dart';
import '../../data/repositories/progress_repository.dart';

part 'entity_event.dart';
part 'entity_state.dart';

class EntityBloc extends Bloc<EntityEvent, EntityState> {
  final DataSyncRepository dataSyncRepo;
  final ProgressRepository progressRepo;

  EntityBloc({
    required this.dataSyncRepo,
    required this.progressRepo,
  }) : super(const EntityInitial()) {
    on<LoadEntities>(_onLoadEntities);
    on<SelectEntity>(_onSelectEntity);
    on<ToggleFavorite>(_onToggleFavorite);
    on<MarkAsLearned>(_onMarkAsLearned);
  }

  Future<void> _onLoadEntities(
    LoadEntities event,
    Emitter<EntityState> emit,
  ) async {
    emit(const EntityLoading());
    try {
      final data = await dataSyncRepo.getData();
      // Find category and subcategory
      final category = data.categories.firstWhere(
        (cat) => cat.id == event.categoryId,
        orElse: () => throw Exception('Category not found'),
      );
      final Subcategory subcategory = category.subcategories.firstWhere(
        (sub) => sub.id == event.subcategoryId,
        orElse: () => throw Exception('Subcategory not found'),
      );
      emit(EntityLoaded(
        entities: subcategory.entities,
        selectedEntity: null,
      ));
    } catch (e) {
      emit(EntityError(e.toString()));
    }
  }

  Future<void> _onSelectEntity(
    SelectEntity event,
    Emitter<EntityState> emit,
  ) async {
    if (state is EntityLoaded) {
      final current = state as EntityLoaded;
      final entity = current.entities.firstWhere(
        (e) => e.id == event.entityId,
        orElse: () => throw Exception('Entity not found'),
      );
      emit(EntityLoaded(
        entities: current.entities,
        selectedEntity: entity,
      ));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<EntityState> emit,
  ) async {
    if (state is EntityLoaded) {
      final current = state as EntityLoaded;
      // Optimistic update
      final newFavs = Map<String, bool>.from(current.favorites);
      newFavs[event.entityId] = !(newFavs[event.entityId] ?? false);
      
      // TODO: get userId from auth state
      await progressRepo.toggleFavorite('guest', event.entityId, newFavs[event.entityId]!);
      
      emit(EntityLoaded(
        entities: current.entities,
        selectedEntity: current.selectedEntity,
        favorites: newFavs,
      ));
    }
  }

  Future<void> _onMarkAsLearned(
    MarkAsLearned event,
    Emitter<EntityState> emit,
  ) async {
    try {
      // TODO: get userId from auth state
      await progressRepo.markAsLearned('guest', event.entityId);
    } catch (e) {
      // Error handled silently or show toast
    }
  }
}
