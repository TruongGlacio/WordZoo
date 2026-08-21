import 'package:flutter/material.dart';
import 'colors_app.dart';
import 'text_stype_constant.dart';

class WebFonts {
  WebFonts._(){
    baseStyle = getBaseTextStyle();
  }

}

class AppThemes {
  AppThemes._();
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData.light().copyWith(
      brightness: Brightness.light,
      primaryColor: ColorConst.primaryColor,
      scaffoldBackgroundColor:ColorConst.bgColor,
      appBarTheme: Theme.of(context).appBarTheme.copyWith(
        backgroundColor: ColorConst.primaryColor,
        iconTheme:  IconThemeData(color: ColorConst.primaryColor),
        centerTitle: true,
        toolbarTextStyle: Theme.of(context).textTheme.apply(bodyColor: ColorConst.primaryColor,).bodyMedium,
        titleTextStyle: Theme.of(context).textTheme.apply(bodyColor: ColorConst.primaryColor,).titleLarge,
      ),
      iconTheme:  IconThemeData(color: ColorConst.primaryColor),
      textTheme: Theme.of(context).textTheme.apply(
        fontFamily: 'SF-Pro',
        bodyColor: ColorConst.primaryColor,
      ),
      colorScheme:  const ColorScheme.light(
        primary: ColorConst.primaryColor,
        secondary: ColorConst.primaryColor,
      ),
      cardColor: ColorConst.primaryColor,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: ColorConst.whiteColor,
        selectedItemColor: ColorConst.primaryColor.withValues(alpha: 0.7),
        unselectedItemColor: ColorConst.primaryColor.withValues(alpha: 0.32),
        selectedIconTheme:  IconThemeData(color: ColorConst.primaryColor),
        showUnselectedLabels: true,
      ),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    return ThemeData.dark().copyWith(
      brightness: Brightness.dark,
      primaryColor: ColorConst.primaryColor,
      scaffoldBackgroundColor: ColorConst.bgColor,
      appBarTheme: Theme.of(context).appBarTheme.copyWith(
        backgroundColor: ColorConst.bgColor,
        iconTheme:  IconThemeData(color: ColorConst.bgColor),
        centerTitle: true, toolbarTextStyle: Theme.of(context).textTheme.apply(
        bodyColor: ColorConst.bgColor,
      ).bodyMedium, titleTextStyle: Theme.of(context).textTheme.apply(
        bodyColor: ColorConst.bgColor,
      ).titleLarge,
      ),
      iconTheme:  IconThemeData(color: ColorConst.bgColor),
      textTheme: Theme.of(context)
          .textTheme
          .apply(
          fontFamily: 'SF-Pro',
          bodyColor: ColorConst.bgColor, displayColor: ColorConst.bgColor),
      colorScheme: const ColorScheme.dark().copyWith(
        primary: ColorConst.primaryColor,
        secondary: ColorConst.primaryColor,
      ),
      cardColor: ColorConst.bgColor,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: ColorConst.primaryColor,
        selectedItemColor: ColorConst.primaryColor,
        unselectedItemColor: ColorConst.primaryColor.withValues(alpha: 0.52),
        selectedIconTheme:  IconThemeData(color: ColorConst.primaryColor),
        showUnselectedLabels: true,
      ),
    );
  }
}

