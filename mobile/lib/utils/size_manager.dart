import 'package:flutter/material.dart';

class SizeManager {
  SizeManager._();

  static final SizeManager instance = SizeManager._();
  factory SizeManager() => instance;

  // Font sizes
  double get headingFontSize => 32.0;
  double get titleFontSize => 24.0;
  double get bodyFontSize => 16.0;
  double get buttonFontSize => 18.0;
  double get signpostFontSize => 20.0;
  double get smallFontSize => 14.0;
  double get captionFontSize => 12.0;

  // Colors for text
  Color get headingColor => const Color(0xFF333333);
  Color get titleColor => const Color(0xFF333333);
  Color get bodyColor => const Color(0xFF555555);
  Color get buttonColor => const Color(0xFFFFFFFF);
  Color get signpostColor => const Color(0xFFFFFFFF);
  Color get smallColor => const Color(0xFF777777);
  Color get captionColor => const Color(0xFF999999);

  // Border radius
  double get borderRadiusSmall => 8.0;
  double get borderRadiusMedium => 12.0;
  double get borderRadiusLarge => 20.0;
  double get borderRadiusXLarge => 24.0;

  // Padding sizes
  EdgeInsets get paddingExtraSmall => const EdgeInsets.all(4.0);
  EdgeInsets get paddingSmall => const EdgeInsets.all(8.0);
  EdgeInsets get paddingMedium => const EdgeInsets.all(16.0);
  EdgeInsets get paddingLarge => const EdgeInsets.all(24.0);
  EdgeInsets get paddingExtraLarge => const EdgeInsets.all(32.0);

  EdgeInsets get paddingHorizontalSmall => const EdgeInsets.symmetric(horizontal: 8.0);
  EdgeInsets get paddingHorizontalMedium => const EdgeInsets.symmetric(horizontal: 16.0);
  EdgeInsets get paddingHorizontalLarge => const EdgeInsets.symmetric(horizontal: 24.0);

  EdgeInsets get paddingVerticalSmall => const EdgeInsets.symmetric(vertical: 8.0);
  EdgeInsets get paddingVerticalMedium => const EdgeInsets.symmetric(vertical: 16.0);
  EdgeInsets get paddingVerticalLarge => const EdgeInsets.symmetric(vertical: 24.0);

  // Margin sizes
  EdgeInsets get marginSmall => const EdgeInsets.all(4.0);
  EdgeInsets get marginMedium => const EdgeInsets.all(8.0);
  EdgeInsets get marginLarge => const EdgeInsets.all(16.0);
  EdgeInsets get marginExtraLarge => const EdgeInsets.all(24.0);

  // Icon sizes
  double get iconSmall => 16.0;
  double get iconMedium => 24.0;
  double get iconLarge => 32.0;
  double get iconXLarge => 48.0;
  double get iconXXLarge => 80.0;

  // Button sizes
  double get buttonHeightSmall => 40.0;
  double get buttonHeightMedium => 50.0;
  double get buttonHeightLarge => 60.0;

  // Spacing sizes
  double get spacingExtraSmall => 4.0;
  double get spacingSmall => 8.0;
  double get spacingMedium => 16.0;
  double get spacingLarge => 24.0;
  double get spacingExtraLarge => 32.0;

  // Image sizes
  double get imageSmall => 48.0;
  double get imageMedium => 80.0;
  double get imageLarge => 120.0;
  double get imageXLarge => 200.0;
}
