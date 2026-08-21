import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:wordzoo/base/theme/text_stype_constant.dart';
import '../../base/resizer/size_manager.dart';

class AppColors {
  static const skyBlue = Color(0xFF87CEEB);
  static const leafGreen = Color(0xFF4CAF50);
  static const sunnyYellow = Color(0xFFFFEB3B);
  static const earthBrown = Color(0xFF795548);
  static const oceanBlue = Color(0xFF2196F3);
  static const coralRed = Color(0xFFF44336);
  static const white = Color(0xFFFFFFFF);
  static const darkText = Color(0xFF333333);
  static const softShadow = Color(0xFFE0E0E0);
  static const gradientSkyGrass = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [skyBlue, leafGreen],
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.leafGreen,
        brightness: Brightness.light,
      ),
      fontFamily: 'Nunito',
      scaffoldBackgroundColor: AppColors.skyBlue,
      cardColor: AppColors.white,
      textTheme: TextTheme(
        displayLarge: TextStyleConstant.heading,
        headlineMedium: TextStyleConstant.title,
        bodyLarge: TextStyleConstant.body,
        labelLarge: TextStyleConstant.button,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens().borderRadiusMedium),
          borderSide: const BorderSide(color: AppColors.earthBrown),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.leafGreen,
          foregroundColor: AppColors.white,
          padding: Dimens().paddingHorizontalLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens().borderRadiusMedium),
          ),
        ),
      ),
    );
  }
}
