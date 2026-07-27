part of 'language_bloc.dart';

sealed class LanguageState extends Equatable {
  const LanguageState();
  @override
  List<Object?> get props => [];
}

class LanguageInitial extends LanguageState {
  const LanguageInitial();
}

class LanguageUpdated extends LanguageState {
  final Locale locale;
  LanguageUpdated({required this.locale});
  @override
  List<Object?> get props => [locale];
}

class PerEntityLanguageUpdated extends LanguageState {
  final String entityId;
  final Locale locale;
  final Locale globalLocale;
  const PerEntityLanguageUpdated({
    required this.entityId,
    required this.locale,
    required this.globalLocale,
  });
  @override
  List<Object?> get props => [entityId, locale, globalLocale];
}
