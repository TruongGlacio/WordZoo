import 'dart:ui';

import 'package:flutter/material.dart';

class SizeManager {
  SizeManager._();

  static final SizeManager instance = SizeManager._();
  factory SizeManager() => instance;
  late final double width;
  late final double height;
  late final double ratioWidth;
  final double standWidthphone = 1920 ;
  void initialScreen(){
    final view = PlatformDispatcher.instance.views.first;
     width = view.physicalSize.width ;
     height = view.physicalSize.height;
     ratioWidth = width/standWidthphone;
     print('ratioHeight: ${ratioWidth}');
  }

  // Font sizes
  double get headingFontSize => 32.0 * ratioWidth;
  double get titleFontSize => 24.0* ratioWidth;
  double get bodyFontSize => 16.0* ratioWidth;
  double get buttonFontSize => 18.0* ratioWidth;
  double get signpostFontSize => 20.0* ratioWidth;
  double get smallFontSize => 14.0* ratioWidth;
  double get captionFontSize => 12.0* ratioWidth;
  double get extraSmallFontSize => 11.0* ratioWidth;

  // Colors for text
  Color get headingColor => const Color(0xFF333333);
  Color get titleColor => const Color(0xFF333333);
  Color get bodyColor => const Color(0xFF555555);
  Color get buttonColor => const Color(0xFFFFFFFF);
  Color get signpostColor => const Color(0xFFFFFFFF);
  Color get smallColor => const Color(0xFF777777);
  Color get captionColor => const Color(0xFF999999);

  // Border radius
  double get borderRadiusSmall => 8.0* ratioWidth;
  double get borderRadiusXSmall => 4.0* ratioWidth;

  double get borderRadiusMedium => 12.0* ratioWidth;
  double get borderRadiusLarge => 16.0* ratioWidth;
  double get borderRadiusXLarge => 24.0* ratioWidth;

  // Padding sizes
  EdgeInsets get paddingExtraSmall =>  EdgeInsets.all(4.0* ratioWidth);
  EdgeInsets get paddingSmall =>  EdgeInsets.all(8.0* ratioWidth);
  EdgeInsets get paddingMedium =>  EdgeInsets.all(16.0* ratioWidth);
  EdgeInsets get paddingLarge =>  EdgeInsets.all(24.0* ratioWidth);
  EdgeInsets get paddingExtraLarge =>  EdgeInsets.all(32.0* ratioWidth);

  EdgeInsets get paddingHorizontalSmall =>  EdgeInsets.symmetric(horizontal: 8.0* ratioWidth);
  EdgeInsets get paddingHorizontalMedium =>  EdgeInsets.symmetric(horizontal: 16.0* ratioWidth);
  EdgeInsets get paddingHorizontalLarge =>  EdgeInsets.symmetric(horizontal: 24.0* ratioWidth);
  EdgeInsets get paddingHorizontalXXXXLarge =>  EdgeInsets.symmetric(horizontal: 120.0* ratioWidth);

  EdgeInsets get paddingVerticalSmall =>  EdgeInsets.symmetric(vertical: 8.0* ratioWidth);
  EdgeInsets get paddingVerticalMedium =>  EdgeInsets.symmetric(vertical: 16.0* ratioWidth);
  EdgeInsets get paddingVerticalLarge =>  EdgeInsets.symmetric(vertical: 24.0* ratioWidth);

  // Margin sizes
  EdgeInsets get marginSmall =>  EdgeInsets.all(4.0* ratioWidth);
  EdgeInsets get marginMedium =>  EdgeInsets.all(8.0* ratioWidth);
  EdgeInsets get marginLarge =>  EdgeInsets.all(16.0* ratioWidth);
  EdgeInsets get marginExtraLarge =>  EdgeInsets.all(24.0* ratioWidth);

  // Icon sizes
  double get iconSmall => 16.0* ratioWidth;
  double get iconMedium => 24.0* ratioWidth;
  double get iconMediumX => 28.0* ratioWidth;

  double get iconLarge => 32.0* ratioWidth;
  double get iconXLarge => 36.0* ratioWidth;
  double get iconXXLarge => 48.0* ratioWidth;
  double get iconXXLarge1 => 60.0* ratioWidth;
  double get iconXXXLarge => 80.0* ratioWidth;
  double get iconXXXXLarge => 120.0* ratioWidth;
  double get iconXXXXXLarge => 160.0* ratioWidth;
  double get iconXXXXXXLarge => 180.0* ratioWidth;
  double get size450 => 450.0* ratioWidth;
  double get size350 => 350.0* ratioWidth;
  double get size200 => 200.0* ratioWidth;

  // Button sizes
  double get buttonHeightSmall => 40.0* ratioWidth;
  double get buttonHeightMedium => 50.0* ratioWidth;
  double get buttonHeightLarge => 60.0* ratioWidth;

  // Spacing sizes
  double get spacing2 => 2.0* ratioWidth;
  double get spacing4 => 4.0* ratioWidth;
  double get spacing8 => 8.0* ratioWidth;
  double get spacing12 => 12.0* ratioWidth;
  double get spacing16 => 16.0* ratioWidth;
  double get spacing20 => 20.0* ratioWidth;
  double get spacing24 => 24.0* ratioWidth;
  double get spacing32 => 32.0* ratioWidth;
  double get spacing40 => 40.0* ratioWidth;
  double get spacing48 => 48.0* ratioWidth;
  double get spacing64 => 64.0* ratioWidth;
  double get spacing128 => 128.0* ratioWidth;

  // Legacy spacing aliases (deprecated, use new names above)
  @Deprecated('Use spacing4 instead')
  double get spacingExtraSmall => spacing4;
  @Deprecated('Use spacing8 instead')
  double get spacingSmall => spacing8;
  @Deprecated('Use spacing16 instead')
  double get spacingMedium => spacing16;
  @Deprecated('Use spacing24 instead')
  double get spacingLarge => spacing24;
  @Deprecated('Use spacing32 instead')
  double get spacingExtraLarge => spacing32;

  // Image sizes
  double get imageXSmall => 36.0* ratioWidth;

  double get imageSmall => 48.0* ratioWidth;
  double get imageMedium => 80.0* ratioWidth;
  double get imageLarge => 120.0* ratioWidth;
  double get imageXLarge => 180.0* ratioWidth;
  double get imageXXLarge => 200.0* ratioWidth;
  double get imageXXXLarge => 220.0* ratioWidth;

}
