import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordzoo/data/datasources/data_manager.dart';

part 'language_event.dart';
part 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  late final SharedPreferences _prefs;

  LanguageBloc() : super(LanguageState(locale: const Locale('en'))) {
    on<ChangeLanguage>(_onChangeLanguage);
    on<TogglePerEntity>(_onTogglePerEntity);
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    final savedLang = _prefs.getString('preferred_language') ?? 'en';
    DataManager().setCurrentLocale(Locale(savedLang));
    emit(LanguageState(locale: Locale(savedLang)));
  }

  Future<void> _onChangeLanguage(
    ChangeLanguage event,
    Emitter<LanguageState> emit,
  ) async {
    await _prefs.setString('preferred_language', event.locale.languageCode);
    DataManager().setCurrentLocale(event.locale);
    emit(LanguageState(locale: event.locale));
  }

  Future<void> _onTogglePerEntity(
    TogglePerEntity event,
    Emitter<LanguageState> emit,
  ) async {
    final current =  (state).locale ?? const Locale('en');
    final next = event.locale;
    await _prefs.setString('entity_lang_${event.entityId}', next.languageCode);
    emit(LanguageState(
        entityId: event.entityId,
        locale: next,
        globalLocale: current,
      ),
    );
  }
}
