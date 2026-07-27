import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const heading = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.darkText,
  );

  static const title = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.darkText,
  );

  static const body = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.darkText,
  );

  static const button = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static const signpost = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );
}
