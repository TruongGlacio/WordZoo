part of 'entity_bloc.dart';

sealed class EntityState extends Equatable {
  const EntityState();
  @override
  List<Object?> get props => [];
}

class EntityInitial extends EntityState {
  const EntityInitial();
}

class EntityLoading extends EntityState {
  const EntityLoading();
}

class EntityLoaded extends EntityState {
  final List<Entity> entities;
  final Entity? selectedEntity;
  final Map<String, bool> favorites;
  final bool? isVisibleDetailPanel;
  const EntityLoaded({
    required this.entities,
    this.selectedEntity,
    this.favorites = const {},
    this.isVisibleDetailPanel
  });

  EntityLoaded copyWith({
    List<Entity>? entities,
    Entity? selectedEntity,
    Map<String, bool>? favorites,
    bool? isVisibleDetailPanel,
  }) {
    return EntityLoaded(
      entities: entities ?? this.entities,
      selectedEntity: selectedEntity ?? this.selectedEntity,
      favorites: favorites ?? this.favorites,
      isVisibleDetailPanel: isVisibleDetailPanel ?? this.isVisibleDetailPanel,
    );
  }

  @override
  List<Object?> get props => [entities, selectedEntity, favorites, isVisibleDetailPanel];
}

class EntityError extends EntityState {
  final String message;
  const EntityError(this.message);
  @override
  List<Object?> get props => [message];
}
