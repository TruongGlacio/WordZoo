import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  late final SharedPreferences _prefs;

  LanguageBloc() : super(const LanguageUpdated(lang: 'vi')) {
    on<ChangeLanguage>(_onChangeLanguage);
    on<TogglePerEntity>(_onTogglePerEntity);
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _onChangeLanguage(
    ChangeLanguage event,
    Emitter<LanguageState> emit,
  ) async {
    await _prefs.setString('preferred_language', event.lang);
    emit(LanguageUpdated(lang: event.lang));
  }

  Future<void> _onTogglePerEntity(
    TogglePerEntity event,
    Emitter<LanguageState> emit,
  ) async {
    final current = state is LanguageUpdated ? (state as LanguageUpdated).lang : 'vi';
    final next = event.lang;
    await _prefs.setString('entity_lang_${event.entityId}', next);
    emit(PerEntityLanguageUpdated(entityId: event.entityId, lang: next, globalLang: current));
  }
}
