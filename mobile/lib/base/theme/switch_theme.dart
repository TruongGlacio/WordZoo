import 'package:flutter/material.dart';
import 'package:wordzoo/base/theme/theme_data.dart';

class SetTheme {
  static bool isDark = false;

  static ThemeData getLightMode(BuildContext context) {
    isDark = false;
    return AppThemes.lightTheme(context);
  }

  static ThemeData getDarkMode(BuildContext context) {
    isDark = true;
    return AppThemes.darkTheme(context);
  }
}
