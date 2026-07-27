import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

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
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.heading,
        headlineMedium: AppTextStyles.title,
        bodyLarge: AppTextStyles.body,
        labelLarge: AppTextStyles.button,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.earthBrown),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.leafGreen,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
