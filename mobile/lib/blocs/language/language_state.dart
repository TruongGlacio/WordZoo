part of 'language_bloc.dart';

class LanguageState extends Equatable {
   String? entityId;
   Locale? locale;
   Locale? globalLocale;
   LanguageState({
     this.entityId,
     this.locale,
     this.globalLocale,
  }){
     locale??= const Locale('vi');
   }
  @override
  List<Object?> get props => [entityId, locale, globalLocale];
}
