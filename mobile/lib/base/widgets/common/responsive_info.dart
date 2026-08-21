import 'dart:math';
import 'package:flutter/cupertino.dart';

import 'package:responsive_framework/responsive_framework.dart';

class ResponsiveInfo {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;
  static late bool _isTablet = false;
  static late bool _isPhone = false;

  static bool isTablet() {
    return _isTablet;
  }

  static bool isPhone() {
    return _isPhone;
  }

  void init(BuildContext context) async {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    final breakpoint = ResponsiveBreakpoints.of(context);
    _isTablet = breakpoint.isTablet;
    _isPhone = breakpoint.isPhone;
  }
}