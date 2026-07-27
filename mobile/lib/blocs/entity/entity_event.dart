part of 'entity_bloc.dart';

sealed class EntityEvent extends Equatable {
  const EntityEvent();
  @override
  List<Object?> get props => [];
}

class LoadEntities extends EntityEvent {
  final String categoryId;
  final String subcategoryId;
  const LoadEntities(this.categoryId, this.subcategoryId);
  @override
  List<Object?> get props => [categoryId, subcategoryId];
}

class SelectEntity extends EntityEvent {
  final String entityId;
  const SelectEntity(this.entityId);
  @override
  List<Object?> get props => [entityId];
}

class ToggleFavorite extends EntityEvent {
  final String entityId;
  const ToggleFavorite(this.entityId);
  @override
  List<Object?> get props => [entityId];
}

class MarkAsLearned extends EntityEvent {
  final String entityId;
  const MarkAsLearned(this.entityId);
  @override
  List<Object?> get props => [entityId];
}
