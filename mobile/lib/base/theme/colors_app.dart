import 'package:flutter/material.dart';
export 'color_extentions.dart';
import 'dart:math';

class ColorConst {
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
  static const brown = Color(0xFF5A3221);
  static const primaryColor = Color(0xFFB76519);
  static const boardColor = Color(0xFFFEE4AD);
  static const gradientSkyGrass = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [skyBlue, grassGreen],
  );
  static Color bgColor = const Color(0xFFF3F4F6);
  static Color bgColor1 = const Color(0xFFE5E7EB);
  static Color bgColor2 = const Color(0x50422C4D);
  static Color mainColor = primaryColor;
  static Color mainBg = bgColor;
  static Color unReadColor = const Color(0xffBAE6FD);
  static Color body = const Color(0xFF334155);
  static Color groupBackground = const Color(0xffE5E7EB);

  static Color neutralLightest = const Color(0xFFF3F4F6);
  static Color neutralLighter = const Color(0xFFE5E7EB);
  static Color neutralLight = const Color(0xFF9CA3AF);
  static Color neutral = const Color(0xFF4B5563);
  static Color neutralDark = const Color(0xFF374151);
  static Color neutralDarker = const Color(0xFF1F2937);
  static Color neutralDarkest = const Color(0xFF111827);

  static Color secondaryLightest = const Color(0xFFEEEFFB);
  static Color secondaryLighter = const Color(0xFFCDD0F4);
  static Color secondaryLight = const Color(0xFF6973DD);
  static Color secondary = const Color(0xFF3744D2);
  static Color secondaryDark = const Color(0xFF2833AF);
  static Color secondaryDarker = const Color(0xFF222C96);
  static Color secondaryDarkest = const Color(0xFF1E2785);

  static Color primaryLightest = const Color(0xFFFAF3E6);
  static Color primaryLighter = const Color(0xFFFFDDB7);
  static Color primaryLight = const Color(0xFFE5B479);
  static Color primary = const Color(0xFFC2812A);
  static Color primaryDark = const Color(0xFFAF6C12);
  static Color primaryDarker = const Color(0xFF9A5910);
  static Color primaryDarkest = const Color(0xFF8F4C00);

  static Color successLightest = const Color(0xFFECFDF5);
  static Color successLighter = const Color(0xFFA7F3D0);
  static Color successLight = const Color(0xFF34D399);
  static Color success = const Color(0xFF059669);
  static Color successDark = const Color(047857);
  static Color successDarker = const Color(0xFF065F46);
  static Color successDarkest = const Color(0xFF064E3B);

  static Color warningLightest = const Color(0xFFFFF7ED);
  static Color warningLighter = const Color(0xFFFED7AA);
  static Color warningLight = const Color(0xFFFB923C);
  static Color warning = const Color(0xFFEA580C);
  static Color warningDark = const Color(0xFFC2410C);
  static Color warningDarker = const Color(0xFF9A3412);
  static Color warningDarkest = const Color(0xFF7C2D12);

  static Color errorLightest = const Color(0xFFFEF2F2);
  static Color errorLighter = const Color(0xFFFECACA);
  static Color errorLight = const Color(0xFFF87171);
  static Color error = const Color(0xFFDC2626);
  static Color errorDark = const Color(0xFFB91C1C);
  static Color errorDarker = const Color(0xFF991B1B);
  static Color errorDarkest = const Color(0xFF7F1D1D);

  static Color infoLightest = const Color(0xFFEFF6FF);
  static Color infoLighter = const Color(0xFFBFDBFE);
  static Color infoLight = const Color(0xFF60A5FA);
  static Color info = const Color(0xFF2563EB);
  static Color infoDark = const Color(0xFF1D4ED8);
  static Color infoDarker = const Color(0xFF1E40AF);
  static Color infoDarkest = const Color(0xFF1E3A8A);

  static Color highlightLightest = const Color(0xFFF5F3FF);
  static Color highlightLighter = const Color(0xFFDDD6FE);
  static Color highlightLight = const Color(0xFFA78BFA);
  static Color highlight = const Color(0xFF7C3AED);
  static Color highlightDark = const Color(0xFF6D28D9);
  static Color highlightDarker = const Color(0xFF5B21B6);
  static Color highlightDarkest = const Color(0xFF4C1D95);

  static Color disable = const Color(0xFF9CADC4);
  static Color shareOn = const Color(0xFFF0F9FF);
  static Color recover = const Color(0xFFFDF2F8);
  static Color surfaceGray = Color(0xFFF1F5F9);
  static Color grey61 = mainColor.withValues(alpha: 0.5);
  static Color greyEE = mainColor.withValues(alpha: 0.5);
  static Color greyF5 = mainColor.withValues(alpha: 0.5);
  static Color homeBg = primaryColor;
  static Color buttonBgColor = primaryColor;
  static Color textColor = Colors.black87;
  static Color textColorOnMainButton = Colors.black87;
  static Color redColor = const Color(0xFFFF0000);

  static Color subtext = const Color(0xff545454);
  static Color borderColor = const Color(0xffCFCFCF);
  static Color progressColor = const Color(0xffC2ECC4);
  static Color whiteColor = Colors.white;
  static Color whiteColor70 = Colors.white70;
  static Color whiteColor10 = Colors.white10;
  static Color loadingBgColor = const Color(0xff091E42).withValues(alpha: 0.05);
  static Color selectColor = const Color(0xff2E438F);

  static Color border1 = const Color(0xFFD9E2ED);
  static Color dividerColor = const Color(0xffE5E7EB);
  static Color blackColor = Colors.black;
  static Color blackColor54 = Colors.black54;
  static Color blackColor45 = Colors.black45;
  static Color blackColor12 = Colors.black12;
  static Color blackColor26 = Colors.black26;
  static Color blackColor87 = Colors.black87;

  static Color colorHintTextSearch = blackColor45;
  static Color iconsGrayColor = const Color(0xFF334155);
  static Color bgToastSuccess = const Color(0xFFE9F7F0);
  static Color bgToastError = const Color(0xFFFFE8E7);
  static Color colorTextRadioButton = const Color(0xFF393939);
  static Color nameRoomAvailable = const Color(0xFF151132);
  static Color normalTextBlackColorOnBackgroundColorWithOpacity70 = blackColor.withValues(alpha: 0.7);
  static Color greyColor1 = Colors.grey;
  static Color greyColor = const Color(0xFF808080);

  static Color colorLinear1 = primaryColor;
  static Color colorLinear2 = const Color(0xffabe127);
  static Color colorLinear3 = const Color(0xffabe127);
  static Color yellowColor = const Color(0xFFE2BD07);

  static Color bgSettingButtonColor = Colors.white;
  static Color bgDialogColor = const Color(0xFFF6FBE5);

  static final List<Color> randomColor = [
    secondary,
    secondaryDark,
    secondaryDarker,
    secondaryDarkest,
    primaryDark,
    primaryDarker,
    primaryDarkest,
    warningDarker,
    warningDarkest,
    error,
    errorDark,
    errorDarker,
    errorDarkest,
    info,
    infoDark,
    infoDarker,
    infoDarkest,
    highlight,
    highlightDark,
    highlightDarker,
    highlightDarkest
  ];
  static Color getRandomColor() {
    // Create a random number generator instance.
    final Random random = Random();

    // Generate a random index within the bounds of the list's length.
    int randomIndex = random.nextInt(randomColor.length);

    // Return the color at the random index.
    return randomColor[randomIndex];
  }
  static String colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0')}';
  }

  static Color hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 7) buffer.write('ff'); // add alpha
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
