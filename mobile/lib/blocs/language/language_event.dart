part of 'language_bloc.dart';

sealed class LanguageEvent extends Equatable {
  const LanguageEvent();
  @override
  List<Object?> get props => [];
}

class ChangeLanguage extends LanguageEvent {
  final String lang;
  const ChangeLanguage(this.lang);
  @override
  List<Object?> get props => [lang];
}

class TogglePerEntity extends LanguageEvent {
  final String entityId;
  final String lang;
  const TogglePerEntity({required this.entityId, required this.lang});
  @override
  List<Object?> get props => [entityId, lang];
}
