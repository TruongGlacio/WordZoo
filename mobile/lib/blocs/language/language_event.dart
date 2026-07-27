part of 'language_bloc.dart';

sealed class LanguageEvent extends Equatable {
  const LanguageEvent();
  @override
  List<Object?> get props => [];
}

class ChangeLanguage extends LanguageEvent {
  final Locale locale;
  const ChangeLanguage(this.locale);
  @override
  List<Object?> get props => [locale];
}

class TogglePerEntity extends LanguageEvent {
  final String entityId;
  final Locale locale;
  const TogglePerEntity({required this.entityId, required this.locale});
  @override
  List<Object?> get props => [entityId, locale];
}
