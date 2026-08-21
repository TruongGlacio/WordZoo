import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wordzoo/base/resizer/size_manager.dart';

import 'colors_app.dart';

// Simple
TextStyle baseStyle =  getBaseTextStyle();
TextStyle getBaseTextStyle1({FontWeight? fontWeight}){
  return TextStyle(
      fontStyle: FontStyle.normal,
      fontWeight: fontWeight??fontWeight400,
      color: ColorConst.blackColor,
      height: height_1_4,
      fontFamily: 'SF-Pro',

    ).copyWithCustom(
      fontWeight: fontWeight??fontWeight400,
      fontFamily: 'SF-Pro',
  );
}
TextStyle getBaseTextStyle({FontWeight? fontWeight}){
  return GoogleFonts.nunito(
      textStyle: TextStyle(
        fontStyle: FontStyle.normal,
        fontWeight: fontWeight??fontWeight400,
        color: ColorConst.blackColor,
        height: height_1_4,
      ).copyWithCustom(
        fontWeight: fontWeight??fontWeight400,
      )
  );
}
const double? textScaleFactorConst =null;
const double height_1_0= 1.1;
const double height_1_1= 1.1;
const double height_1_2= 1.2;
const double height_1_3= 1.3;
const double height_1_4= 1.4;

double fontSize36 = Dimens().size36;
double fontSize35 = Dimens().size35;
double fontSize31 = Dimens().size31;
double fontSize30 = Dimens().size30;
double fontSize27 = Dimens().size27;
double fontSize24 = Dimens().size24;
double fontSize23 = Dimens().size23;
double fontSize21 = Dimens().size21;
double fontSize20 = Dimens().size20;
double fontSize19 = Dimens().size19;
double fontSize18 = Dimens().size18;
double fontSize17 = Dimens().size17;
double fontSize16 = Dimens().size16;
double fontSize15 = Dimens().size15;
double fontSize14 = Dimens().size14;
double fontSize13 = Dimens().size13;
double fontSize12 = Dimens().size12;
double fontSize11 = Dimens().size11;
double fontSize10 = Dimens().size10;


 FontWeight fontWeight300 = FontWeight.w300;
 FontWeight fontWeight400 = FontWeight.w400;
 FontWeight fontWeight500 = FontWeight.w500;
 FontWeight fontWeight600 = FontWeight.w600;
 FontWeight fontWeight700 = FontWeight.w700;
 FontWeight fontWeight800 = FontWeight.w800;
 FontWeight fontWeight900 = FontWeight.w900;

 class FontSizeConstant{
   double small = Dimens().size10;
   double medium = Dimens().size10;
   double large = Dimens().size10;
 }

class TextStyleConstant{
  static const String defaultFontFamily = "SF-Pro";
  static TextStyle get heading => baseStyle.copyWithCustom(fontSize: Dimens().headingFontSize, fontWeight: FontWeight.bold, color: Dimens().headingColor,);
  static TextStyle get title => baseStyle.copyWithCustom(fontSize: Dimens().titleFontSize, fontWeight: FontWeight.bold, color: Dimens().titleColor,);
  static TextStyle get body => baseStyle.copyWithCustom(fontSize: Dimens().bodyFontSize, fontWeight: FontWeight.normal, color: Dimens().bodyColor,);
  static TextStyle get button => baseStyle.copyWithCustom(fontSize: Dimens().buttonFontSize, fontWeight: FontWeight.w600, color: Dimens().buttonColor,);
  static TextStyle get signpost => baseStyle.copyWithCustom(fontSize: Dimens().signpostFontSize, fontWeight: FontWeight.bold, color: Dimens().signpostColor,);
  static TextStyle get small => baseStyle.copyWithCustom(fontSize: Dimens().smallFontSize, fontWeight: FontWeight.normal, color: Dimens().smallColor,);
  static TextStyle get caption => baseStyle.copyWithCustom(fontSize: Dimens().captionFontSize, fontWeight: FontWeight.normal, color: Dimens().captionColor,);
  static 	TextStyle h1= baseStyle.copyWithCustom(fontSize: fontSize31, color: ColorConst.neutralDarker, fontWeight: fontWeight600);
  static 	TextStyle h2= baseStyle.copyWithCustom(fontSize: fontSize27, color: ColorConst.neutralDarker, fontWeight: fontWeight600);
  static 	TextStyle h3= baseStyle.copyWithCustom(fontSize: fontSize23, color: ColorConst.neutralDarker, fontWeight: fontWeight600);
  static 	TextStyle h4= baseStyle.copyWithCustom(fontSize: fontSize21, color: ColorConst.neutralDarker, fontWeight: fontWeight600);
  static 	TextStyle h5= baseStyle.copyWithCustom(fontSize: fontSize19, color: ColorConst.neutralDarker, fontWeight: fontWeight600);
  static 	TextStyle h6= baseStyle.copyWithCustom(fontSize: fontSize17, color: ColorConst.neutralDarker, fontWeight: fontWeight600);
  static 	TextStyle h7= baseStyle.copyWithCustom(fontSize: fontSize15, color: ColorConst.neutralDarker, fontWeight: fontWeight600);
  static 	TextStyle h8= baseStyle.copyWithCustom(fontSize: fontSize14, color: ColorConst.neutralDarker, fontWeight: fontWeight600);

  static 	TextStyle subtitle1= baseStyle.copyWithCustom(fontSize: fontSize17, color: ColorConst.neutralDarker, fontWeight: fontWeight500);
  static 	TextStyle subtitle2= baseStyle.copyWithCustom(fontSize: fontSize15, color: ColorConst.neutralDarker, fontWeight: fontWeight500);
  static 	TextStyle subtitle3= baseStyle.copyWithCustom(fontSize: fontSize14, color: ColorConst.neutralDarker, fontWeight: fontWeight500);
  static 	TextStyle subtitle4= baseStyle.copyWithCustom(fontSize: fontSize13, color: ColorConst.neutralDarker, fontWeight: fontWeight500);
  static 	TextStyle subtitle5= baseStyle.copyWithCustom(fontSize: fontSize12, color: ColorConst.neutralDarker, fontWeight: fontWeight500);

  static 	TextStyle body1= baseStyle.copyWithCustom(fontSize: fontSize17, color: ColorConst.neutralDarker, fontWeight: fontWeight400);
  static 	TextStyle body2= baseStyle.copyWithCustom(fontSize: fontSize15, color: ColorConst.neutralDarker, fontWeight: fontWeight400);
  static 	TextStyle body3= baseStyle.copyWithCustom(fontSize: fontSize14, color: ColorConst.neutralDarker, fontWeight: fontWeight400);
  static 	TextStyle body4= baseStyle.copyWithCustom(fontSize: fontSize13, color: ColorConst.neutralDarker, fontWeight: fontWeight400);
  static 	TextStyle body5= baseStyle.copyWithCustom(fontSize: fontSize12, color: ColorConst.neutralDarker, fontWeight: fontWeight400);

  static 	TextStyle button1= baseStyle.copyWithCustom(fontSize: fontSize17, color: ColorConst.neutralDarker, fontWeight: fontWeight600);
  static 	TextStyle button2= baseStyle.copyWithCustom(fontSize: fontSize15, color: ColorConst.neutralDarker, fontWeight: fontWeight600);



  static void resetStyle(BuildContext context){
    final ts = MediaQuery.textScalerOf(context);
    double res = ts.scale(1.0);
    if(res<0.9) {
      res=0.9;
    }
    if(res>1.2) {
      res=1.2;
    }
     fontSize36 = Dimens().size36/res;
     fontSize35 = Dimens().size35/res;
     fontSize30 = Dimens().size30/res;
     fontSize24 = Dimens().size24/res;
     fontSize20 = Dimens().size22/res;
     fontSize18 = Dimens().size19/res;
     fontSize17 = Dimens().size18/res;
     fontSize16 = Dimens().size17/res;
     fontSize15 = Dimens().size16/res;
     fontSize14 = Dimens().size15/res;
     fontSize13 = Dimens().size14/res;
     fontSize12 = Dimens().size13/res;
     fontSize10 = Dimens().size11/res;
     
     fontWeight300 = FontWeight.w300;
     fontWeight400 = FontWeight.w400;
     fontWeight500 = FontWeight.w500;
     fontWeight600 = FontWeight.w600;
     fontWeight700 = FontWeight.w700;
     fontWeight800 = FontWeight.w800;
     fontWeight900 = FontWeight.w900;
  }
}
extension StringX on TextStyle {
  TextStyle copyWithCustom({
    bool? inherit,
    Color? color,
    Color? backgroundColor,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextBaseline? textBaseline,
    double? height,
    TextLeadingDistribution? leadingDistribution,
    Locale? locale,
    Paint? foreground,
    Paint? background,
    List<Shadow>? shadows,
    List<FontFeature>? fontFeatures,
    List<FontVariation>? fontVariations,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    String? debugLabel,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    String? package,
    TextOverflow? overflow,
  }){
    return copyWith(
        inherit: inherit,
        color: color,
        backgroundColor: backgroundColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        textBaseline: textBaseline,
        height: height,
        leadingDistribution: leadingDistribution,
        locale: locale,
        foreground: foreground,
        background: background,
        shadows: shadows,
        fontFeatures: fontFeatures,
        fontVariations: fontVariations?? [
          FontVariation(
              'wght', (((fontWeight??fontWeight400).index) * 100).toDouble())
        ],
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        decorationThickness: decorationThickness,
        debugLabel: debugLabel,
        fontFamily: fontFamily??'SF-Pro',
        fontFamilyFallback: fontFamilyFallback,
        package: package,
        overflow: overflow
    );
  }
}