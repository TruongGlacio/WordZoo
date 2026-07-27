import 'package:flutter/material.dart';
import '../../utils/font_manager.dart';
import '../../utils/size_manager.dart';

class AppTextStyles {
  static TextStyle get heading => FontManager.instance.heading;
  static TextStyle get title => FontManager.instance.title;
  static TextStyle get body => FontManager.instance.body;
  static TextStyle get button => FontManager.instance.button;
  static TextStyle get signpost => FontManager.instance.signpost;
  static TextStyle get small => FontManager.instance.small;
  static TextStyle get caption => FontManager.instance.caption;
}
