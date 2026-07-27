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
  final String lang;
  const LanguageUpdated({required this.lang});
  @override
  List<Object?> get props => [lang];
}

class PerEntityLanguageUpdated extends LanguageState {
  final String entityId;
  final String lang;
  final String globalLang;
  const PerEntityLanguageUpdated({
    required this.entityId,
    required this.lang,
    required this.globalLang,
  });
  @override
  List<Object?> get props => [entityId, lang, globalLang];
}
