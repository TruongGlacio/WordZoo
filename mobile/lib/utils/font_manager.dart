import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'size_manager.dart';

class FontManager {
  FontManager._();

  static final FontManager instance = FontManager._();
  factory FontManager() => instance;

  TextStyle get heading => GoogleFonts.nunito(
        fontSize: SizeManager.instance.headingFontSize,
        fontWeight: FontWeight.bold,
        color: SizeManager.instance.headingColor,
      );

  TextStyle get title => GoogleFonts.nunito(
        fontSize: SizeManager.instance.titleFontSize,
        fontWeight: FontWeight.bold,
        color: SizeManager.instance.titleColor,
      );

  TextStyle get body => GoogleFonts.nunito(
        fontSize: SizeManager.instance.bodyFontSize,
        fontWeight: FontWeight.normal,
        color: SizeManager.instance.bodyColor,
      );

  TextStyle get button => GoogleFonts.nunito(
        fontSize: SizeManager.instance.buttonFontSize,
        fontWeight: FontWeight.w600,
        color: SizeManager.instance.buttonColor,
      );

  TextStyle get signpost => GoogleFonts.nunito(
        fontSize: SizeManager.instance.signpostFontSize,
        fontWeight: FontWeight.bold,
        color: SizeManager.instance.signpostColor,
      );

  TextStyle get small => GoogleFonts.nunito(
        fontSize: SizeManager.instance.smallFontSize,
        fontWeight: FontWeight.normal,
        color: SizeManager.instance.smallColor,
      );

  TextStyle get caption => GoogleFonts.nunito(
        fontSize: SizeManager.instance.captionFontSize,
        fontWeight: FontWeight.normal,
        color: SizeManager.instance.captionColor,
      );
}
