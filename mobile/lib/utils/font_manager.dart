import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'size_manager.dart';

class FontManager {
  FontManager._();

  static final FontManager instance = FontManager._();
  factory FontManager() => instance;

  TextStyle get heading => GoogleFonts.nunito(
        fontSize: SizeManager().headingFontSize,
        fontWeight: FontWeight.bold,
        color: SizeManager().headingColor,
      );

  TextStyle get title => GoogleFonts.nunito(
        fontSize: SizeManager().titleFontSize,
        fontWeight: FontWeight.bold,
        color: SizeManager().titleColor,
      );

  TextStyle get body => GoogleFonts.nunito(
        fontSize: SizeManager().bodyFontSize,
        fontWeight: FontWeight.normal,
        color: SizeManager().bodyColor,
      );

  TextStyle get button => GoogleFonts.nunito(
        fontSize: SizeManager().buttonFontSize,
        fontWeight: FontWeight.w600,
        color: SizeManager().buttonColor,
      );

  TextStyle get signpost => GoogleFonts.nunito(
        fontSize: SizeManager().signpostFontSize,
        fontWeight: FontWeight.bold,
        color: SizeManager().signpostColor,
      );

  TextStyle get small => GoogleFonts.nunito(
        fontSize: SizeManager().smallFontSize,
        fontWeight: FontWeight.normal,
        color: SizeManager().smallColor,
      );

  TextStyle get caption => GoogleFonts.nunito(
        fontSize: SizeManager().captionFontSize,
        fontWeight: FontWeight.normal,
        color: SizeManager().captionColor,
      );
}
