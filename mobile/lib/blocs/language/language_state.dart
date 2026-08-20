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
   LanguageState copyWith({
     String? entityId,
     Locale? locale,
     Locale? globalLocale
   }) {
     return LanguageState(
       entityId: entityId ?? this.entityId,
       locale: locale ?? this.locale,
       globalLocale: globalLocale ?? this.globalLocale,
     );
   }
  @override
  List<Object?> get props => [entityId, locale, globalLocale];
}
