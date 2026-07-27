import 'package:flutter/material.dart';

class AppColors {
  static const skyBlue = Color(0xFF87CEEB);
  static const leafGreen = Color(0xFF7CB342);
  static const sunnyYellow = Color(0xFFFFD54F);
  static const earthBrown = Color(0xFF8D6E63);
  static const oceanBlue = Color(0xFF42A5F5);
  static const grassGreen = Color(0xFFAED581);
  static const coralRed = Color(0xFFFF7043);
  static const white = Color(0xFFFFFFFF);
  static const darkText = Color(0xFF37474F);
  static const softShadow = Color(0x1A000000);

  static const gradientSkyGrass = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [skyBlue, grassGreen],
  );
}
