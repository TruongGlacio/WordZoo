import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wordzoo/base/resizer/fetch_pixels.dart';

class Dimens {
  Dimens._();

  static final Dimens instance = Dimens._();
  factory Dimens() => instance;
  late final double width;
  late final double height;
  late final double ratioWidth;
  final double standWidthphone = 1920 ;
  void initialScreen(){
    final view = PlatformDispatcher.instance.views.first;

     width = view.physicalSize.width ;
     height = view.physicalSize.height;
     ratioWidth = width/standWidthphone;
     print('ratioHeight: $ratioWidth');
  }

  // Font sizes
  double get headingFontSize => FetchPixels().getPixelHeight(32.0 * ratioWidth );
  double get titleFontSize => FetchPixels().getPixelHeight(24.0 * ratioWidth );
  double get bodyFontSize => FetchPixels().getPixelHeight(16.0 * ratioWidth );
  double get buttonFontSize => FetchPixels().getPixelHeight(18.0 * ratioWidth );
  double get signpostFontSize => FetchPixels().getPixelHeight(20.0 * ratioWidth );
  double get smallFontSize => FetchPixels().getPixelHeight(14.0 * ratioWidth );
  double get captionFontSize => FetchPixels().getPixelHeight(12.0 * ratioWidth );
  double get extraSmallFontSize => FetchPixels().getPixelHeight(11.0 * ratioWidth );

  // Colors for text
  Color get headingColor => const Color(0xFF333333);
  Color get titleColor => const Color(0xFF333333);
  Color get bodyColor => const Color(0xFF555555);
  Color get buttonColor => const Color(0xFFFFFFFF);
  Color get signpostColor => const Color(0xFFFFFFFF);
  Color get smallColor => const Color(0xFF777777);
  Color get captionColor => const Color(0xFF999999);

  // Border radius
  double get borderRadiusSmall => FetchPixels().getPixelHeight(8.0 * ratioWidth );
  double get borderRadiusXSmall => FetchPixels().getPixelHeight(4.0 * ratioWidth );

  double get borderRadiusMedium => FetchPixels().getPixelHeight(12.0 * ratioWidth );
  double get borderRadiusLarge => FetchPixels().getPixelHeight(16.0 * ratioWidth );
  double get borderRadiusXLarge => FetchPixels().getPixelHeight(24.0 * ratioWidth );

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
  double get iconSmall => FetchPixels().getPixelHeight(16.0 * ratioWidth );
  double get iconMedium => FetchPixels().getPixelHeight(24.0 * ratioWidth );
  double get iconMediumX => FetchPixels().getPixelHeight(28.0 * ratioWidth );

  double get iconLarge => FetchPixels().getPixelHeight(32.0 * ratioWidth );
  double get iconXLarge => FetchPixels().getPixelHeight(36.0 * ratioWidth );
  double get iconXXLarge => FetchPixels().getPixelHeight(48.0 * ratioWidth );
  double get iconXXLarge1 => FetchPixels().getPixelHeight(60.0 * ratioWidth );
  double get iconXXXLarge => FetchPixels().getPixelHeight(80.0 * ratioWidth );
  double get iconXXXXLarge => FetchPixels().getPixelHeight(120.0 * ratioWidth );
  double get iconXXXXXLarge => FetchPixels().getPixelHeight(160.0 * ratioWidth );
  double get iconXXXXXXLarge => FetchPixels().getPixelHeight(180.0 * ratioWidth );


  // Button sizes
  double get buttonHeightSmall => FetchPixels().getPixelHeight(40.0 * ratioWidth );
  double get buttonHeightMedium => FetchPixels().getPixelHeight(50.0 * ratioWidth );
  double get buttonHeightLarge => FetchPixels().getPixelHeight(60.0 * ratioWidth );

  // Spacing sizes
  double  get spacing1 => FetchPixels().getPixelHeight(1);
  double get spacing2 => FetchPixels().getPixelHeight(2.0 * ratioWidth );
  double get spacing4 => FetchPixels().getPixelHeight(4.0 * ratioWidth );
  double get spacing8 => FetchPixels().getPixelHeight(8.0 * ratioWidth );
  double get spacing12 => FetchPixels().getPixelHeight(12.0 * ratioWidth );
  double get spacing16 => FetchPixels().getPixelHeight(16.0 * ratioWidth );
  double get spacing20 => FetchPixels().getPixelHeight(20.0 * ratioWidth );
  double get spacing24 => FetchPixels().getPixelHeight(24.0 * ratioWidth );
  double get spacing32 => FetchPixels().getPixelHeight(32.0 * ratioWidth );
  double get spacing40 => FetchPixels().getPixelHeight(40.0 * ratioWidth );
  double get spacing48 => FetchPixels().getPixelHeight(48.0 * ratioWidth );
  double get spacing64 => FetchPixels().getPixelHeight(64.0 * ratioWidth );
  double get spacing128 => FetchPixels().getPixelHeight(128.0 * ratioWidth );
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
  double get imageXtraSmall => FetchPixels().getPixelHeight(24.0 * ratioWidth );

  double get imageXTraXSmall => FetchPixels().getPixelHeight(36.0 * ratioWidth );

  double get imageSmall => FetchPixels().getPixelHeight(48.0 * ratioWidth );
  double get imageMedium => FetchPixels().getPixelHeight(80.0 * ratioWidth );
  double get imageLarge => FetchPixels().getPixelHeight(120.0 * ratioWidth );
  double get imageXLarge => FetchPixels().getPixelHeight(180.0 * ratioWidth );
  double get imageXXLarge => FetchPixels().getPixelHeight(200.0 * ratioWidth );
  double get imageXXXLarge => FetchPixels().getPixelHeight(220.0 * ratioWidth );

  double get size0 => FetchPixels().getPixelHeight(0.0 * ratioWidth );
  double get size0_5 => FetchPixels().getPixelHeight(0.5);
  double get size1 => FetchPixels().getPixelHeight(1.0 * ratioWidth );
  double get size1_3 => FetchPixels().getPixelHeight(1.3);
  double get size1_5 => FetchPixels().getPixelHeight(1.5);
  double get size2 => FetchPixels().getPixelHeight(2.0 * ratioWidth );
  double get size3 => FetchPixels().getPixelHeight(3.0 * ratioWidth );
  double get size4 => FetchPixels().getPixelHeight(4.0 * ratioWidth );
  double get size5 => FetchPixels().getPixelHeight(5.0 * ratioWidth );
  double get size6 => FetchPixels().getPixelHeight(6.0 * ratioWidth );
  double get size7 => FetchPixels().getPixelHeight(7.0 * ratioWidth );
  double get size8 => FetchPixels().getPixelHeight(8.0 * ratioWidth );
  double get size9 => FetchPixels().getPixelHeight(9.0 * ratioWidth );
  double get size10 => FetchPixels().getPixelHeight(10.0 * ratioWidth );
  double get radiusExtraLarge => FetchPixels().getPixelHeight(32* ratioWidth );
  double get radiusLarge => FetchPixels().getPixelHeight(24* ratioWidth );
  double get radiusMedium => FetchPixels().getPixelHeight(16* ratioWidth );
  double get radiusSmall => FetchPixels().getPixelHeight(8* ratioWidth );
  double get radiusExtraSmall => FetchPixels().getPixelHeight(4* ratioWidth );



  double get paddingExtraLarge => FetchPixels().getPixelHeight(32* ratioWidth );
  double get paddingLarge => FetchPixels().getPixelHeight(24* ratioWidth );
  double get paddingMedium => FetchPixels().getPixelHeight(16* ratioWidth );
  double get paddingSmall => FetchPixels().getPixelHeight(8* ratioWidth );
  double get paddingExtraSmall => FetchPixels().getPixelHeight(4* ratioWidth );
  double get iconsSize1 => FetchPixels().getPixelHeight(25* ratioWidth );
  double get tabBarHeight => FetchPixels().getPixelHeight(56* ratioWidth );
  double get tabBarHeightMax => FetchPixels().getPixelHeight(80* ratioWidth );

  double get size11 {
    return FetchPixels().getPixelHeight((!FetchPixels().breakpoint.isTablet?11.0:11.0) * ratioWidth );
  }

  double get size12 {
    return FetchPixels().getPixelHeight((!FetchPixels().breakpoint.isTablet?12.0:12.0) * ratioWidth );
  }
  double get size13 {
    return FetchPixels().getPixelHeight((!FetchPixels().breakpoint.isTablet?13.0:13.0)* ratioWidth ) ;
  }
  double get size14 {
    return FetchPixels().getPixelHeight((!FetchPixels().breakpoint.isTablet?14.0:14.0) * ratioWidth );
  }
  double get size15 {
    return FetchPixels().getPixelHeight((!FetchPixels().breakpoint.isTablet?15.0:15.0) * ratioWidth ) ;
  }
  double get size16{
    return FetchPixels().getPixelHeight((!FetchPixels().breakpoint.isTablet?16.0:16.0) * ratioWidth );
  }
  double get size17 {
    return FetchPixels().getPixelHeight((!FetchPixels().breakpoint.isTablet?17.0:17.0 )* ratioWidth );
  }
  double get size18 {
    return FetchPixels().getPixelHeight((!FetchPixels().breakpoint.isTablet?18.0:18.0) * ratioWidth );
  }
  double get size19 {
    return FetchPixels().getPixelHeight((!FetchPixels().breakpoint.isTablet?19.0:19.0) * ratioWidth );
  }
  double get size20 {
    return FetchPixels().getPixelHeight((!FetchPixels().breakpoint.isTablet?20.0:20.0) * ratioWidth );
  }
  double get size21 {
    return FetchPixels().getPixelHeight((!FetchPixels().breakpoint.isTablet?21.0:21.0) * ratioWidth );
  }
  double get size22 {
    return FetchPixels().getPixelHeight((!FetchPixels().breakpoint.isTablet?22.0:22.0) * ratioWidth );
  }
  double get size23 {
    return FetchPixels().getPixelHeight((!FetchPixels().breakpoint.isTablet?23.0:23.0) * ratioWidth );
  }
  double get size24 {
    return FetchPixels().getPixelHeight((!FetchPixels().breakpoint.isTablet?24.0:24.0) * ratioWidth );
  }
  double get size25 {
    return FetchPixels().getPixelHeight((!FetchPixels().breakpoint.isTablet?25.0:25.0) * ratioWidth );
  }
  double get size26 {
    return FetchPixels().getPixelHeight((!FetchPixels().breakpoint.isTablet?26.0:26.0) * ratioWidth );
  }
  double get size27 => FetchPixels().getPixelHeight(27.0 * ratioWidth );
  double get size28 => FetchPixels().getPixelHeight(28.0 * ratioWidth );
  double get size29 => FetchPixels().getPixelHeight(29.0 * ratioWidth );
  double get size30 => FetchPixels().getPixelHeight(30.0 * ratioWidth );
  double get size31 => FetchPixels().getPixelHeight(31.0 * ratioWidth );
  double get size32 => FetchPixels().getPixelHeight(32.0 * ratioWidth );
  double get size33 => FetchPixels().getPixelHeight(33.0 * ratioWidth );
  double get size34 => FetchPixels().getPixelHeight(34.0 * ratioWidth );
  double get size35 => FetchPixels().getPixelHeight((!FetchPixels().breakpoint.isTablet?35.0:35)* ratioWidth );
  double get size36 => FetchPixels().getPixelHeight(36.0 * ratioWidth );
  double get size37 => FetchPixels().getPixelHeight(37.0 * ratioWidth );
  double get size38 => FetchPixels().getPixelHeight(38.0 * ratioWidth );
  double get size39 => FetchPixels().getPixelHeight(39.0 * ratioWidth );
  double get size40 => FetchPixels().getPixelHeight(40.0 * ratioWidth );
  double get size41 => FetchPixels().getPixelHeight(41.0 * ratioWidth );
  double get size42 => FetchPixels().getPixelHeight(42.0 * ratioWidth );
  double get size43 => FetchPixels().getPixelHeight(43.0 * ratioWidth );
  double get size44 => FetchPixels().getPixelHeight(44.0 * ratioWidth );
  double get size45 => FetchPixels().getPixelHeight(45.0 * ratioWidth );
  double get size46 => FetchPixels().getPixelHeight(46.0 * ratioWidth );
  double get size47 => FetchPixels().getPixelHeight(47.0 * ratioWidth );
  double get size48 => FetchPixels().getPixelHeight(48.0 * ratioWidth );
  double get size49 => FetchPixels().getPixelHeight(49.0 * ratioWidth );
  double get size50 => FetchPixels().getPixelHeight(50.0 * ratioWidth );
  double get size51 => FetchPixels().getPixelHeight(51.0 * ratioWidth );
  double get size52 => FetchPixels().getPixelHeight(52.0 * ratioWidth );
  double get size53 => FetchPixels().getPixelHeight(53.0 * ratioWidth );
  double get size54 => FetchPixels().getPixelHeight(54.0 * ratioWidth );
  double get size55 => FetchPixels().getPixelHeight(55.0 * ratioWidth );
  double get size56 => FetchPixels().getPixelHeight(56.0 * ratioWidth );
  double get size57 => FetchPixels().getPixelHeight(57.0 * ratioWidth );
  double get size58 => FetchPixels().getPixelHeight(58.0 * ratioWidth );
  double get size59 => FetchPixels().getPixelHeight(59.0 * ratioWidth );
  double get size60 => FetchPixels().getPixelHeight(60.0 * ratioWidth );
  double get size61 => FetchPixels().getPixelHeight(61.0 * ratioWidth );
  double get size62 => FetchPixels().getPixelHeight(62.0 * ratioWidth );
  double get size63 => FetchPixels().getPixelHeight(63.0 * ratioWidth );
  double get size64 => FetchPixels().getPixelHeight(64.0 * ratioWidth );
  double get size65 => FetchPixels().getPixelHeight(65.0 * ratioWidth );
  double get size66 => FetchPixels().getPixelHeight(66.0 * ratioWidth );
  double get size67 => FetchPixels().getPixelHeight(67.0 * ratioWidth );
  double get size68 => FetchPixels().getPixelHeight(68.0 * ratioWidth );
  double get size69 => FetchPixels().getPixelHeight(69.0 * ratioWidth );
  double get size70 => FetchPixels().getPixelHeight(70.0 * ratioWidth );
  double get size71 => FetchPixels().getPixelHeight(71.0 * ratioWidth );
  double get size72 => FetchPixels().getPixelHeight(72.0 * ratioWidth );
  double get size73 => FetchPixels().getPixelHeight(73.0 * ratioWidth );
  double get size74 => FetchPixels().getPixelHeight(74.0 * ratioWidth );
  double get size75 => FetchPixels().getPixelHeight(75.0 * ratioWidth );
  double get size76 => FetchPixels().getPixelHeight(76.0 * ratioWidth );
  double get size77 => FetchPixels().getPixelHeight(77.0 * ratioWidth );
  double get size78 => FetchPixels().getPixelHeight(78.0 * ratioWidth );
  double get size79 => FetchPixels().getPixelHeight(79.0 * ratioWidth );
  double get size80 => FetchPixels().getPixelHeight(80.0 * ratioWidth );
  double get size81 => FetchPixels().getPixelHeight(81.0 * ratioWidth );
  double get size82 => FetchPixels().getPixelHeight(82.0 * ratioWidth );
  double get size83 => FetchPixels().getPixelHeight(83.0 * ratioWidth );
  double get size84 => FetchPixels().getPixelHeight(84.0 * ratioWidth );
  double get size85 => FetchPixels().getPixelHeight(85.0 * ratioWidth );
  double get size86 => FetchPixels().getPixelHeight(86.0 * ratioWidth );
  double get size87 => FetchPixels().getPixelHeight(87.0 * ratioWidth );
  double get size88 => FetchPixels().getPixelHeight(88.0 * ratioWidth );
  double get size89 => FetchPixels().getPixelHeight(89.0 * ratioWidth );
  double get size90 => FetchPixels().getPixelHeight(90.0 * ratioWidth );
  double get size91 => FetchPixels().getPixelHeight(91.0 * ratioWidth );
  double get size92 => FetchPixels().getPixelHeight(92.0 * ratioWidth );
  double get size93 => FetchPixels().getPixelHeight(93.0 * ratioWidth );
  double get size94 => FetchPixels().getPixelHeight(94.0 * ratioWidth );
  double get size95 => FetchPixels().getPixelHeight(95.0 * ratioWidth );
  double get size96 => FetchPixels().getPixelHeight(96.0 * ratioWidth );
  double get size97 => FetchPixels().getPixelHeight(97.0 * ratioWidth );
  double get size98 => FetchPixels().getPixelHeight(98.0 * ratioWidth );
  double get size99 => FetchPixels().getPixelHeight(99.0 * ratioWidth );
  double get size100 => FetchPixels().getPixelHeight(100.0 * ratioWidth );
  double get size101 => FetchPixels().getPixelHeight(101.0 * ratioWidth );
  double get size102 => FetchPixels().getPixelHeight(102.0 * ratioWidth );
  double get size103 => FetchPixels().getPixelHeight(103.0 * ratioWidth );
  double get size104 => FetchPixels().getPixelHeight(104.0 * ratioWidth );
  double get size105 => FetchPixels().getPixelHeight(105.0 * ratioWidth );
  double get size106 => FetchPixels().getPixelHeight(106.0 * ratioWidth );
  double get size107 => FetchPixels().getPixelHeight(107.0 * ratioWidth );
  double get size108 => FetchPixels().getPixelHeight(108.0 * ratioWidth );
  double get size109 => FetchPixels().getPixelHeight(109.0 * ratioWidth );
  double get size110 => FetchPixels().getPixelHeight(110.0 * ratioWidth );
  double get size111 => FetchPixels().getPixelHeight(111.0 * ratioWidth );
  double get size112 => FetchPixels().getPixelHeight(112.0 * ratioWidth );
  double get size113 => FetchPixels().getPixelHeight(113.0 * ratioWidth );
  double get size114 => FetchPixels().getPixelHeight(114.0 * ratioWidth );
  double get size115 => FetchPixels().getPixelHeight(115.0 * ratioWidth );
  double get size116 => FetchPixels().getPixelHeight(116.0 * ratioWidth );
  double get size117 => FetchPixels().getPixelHeight(117.0 * ratioWidth );
  double get size118 => FetchPixels().getPixelHeight(118.0 * ratioWidth );
  double get size119 => FetchPixels().getPixelHeight(119.0 * ratioWidth );
  double get size120 => FetchPixels().getPixelHeight(120.0 * ratioWidth );
  double get size121 => FetchPixels().getPixelHeight(121.0 * ratioWidth );
  double get size122 => FetchPixels().getPixelHeight(122.0 * ratioWidth );
  double get size123 => FetchPixels().getPixelHeight(123.0 * ratioWidth );
  double get size124 => FetchPixels().getPixelHeight(124.0 * ratioWidth );
  double get size125 => FetchPixels().getPixelHeight(125.0 * ratioWidth );
  double get size126 => FetchPixels().getPixelHeight(126.0 * ratioWidth );
  double get size127 => FetchPixels().getPixelHeight(127.0 * ratioWidth );
  double get size128 => FetchPixels().getPixelHeight(128.0 * ratioWidth );
  double get size129 => FetchPixels().getPixelHeight(129.0 * ratioWidth );
  double get size130 => FetchPixels().getPixelHeight(130.0 * ratioWidth );
  double get size131 => FetchPixels().getPixelHeight(131.0 * ratioWidth );
  double get size132 => FetchPixels().getPixelHeight(132.0 * ratioWidth );
  double get size133 => FetchPixels().getPixelHeight(133.0 * ratioWidth );
  double get size134 => FetchPixels().getPixelHeight(134.0 * ratioWidth );
  double get size135 => FetchPixels().getPixelHeight(135.0 * ratioWidth );
  double get size136 => FetchPixels().getPixelHeight(136.0 * ratioWidth );
  double get size137 => FetchPixels().getPixelHeight(137.0 * ratioWidth );
  double get size138 => FetchPixels().getPixelHeight(138.0 * ratioWidth );
  double get size139 => FetchPixels().getPixelHeight(139.0 * ratioWidth );
  double get size140 => FetchPixels().getPixelHeight(140.0 * ratioWidth );
  double get size141 => FetchPixels().getPixelHeight(141.0 * ratioWidth );
  double get size142 => FetchPixels().getPixelHeight(142.0 * ratioWidth );
  double get size143 => FetchPixels().getPixelHeight(143.0 * ratioWidth );
  double get size144 => FetchPixels().getPixelHeight(144.0 * ratioWidth );
  double get size145 => FetchPixels().getPixelHeight(145.0 * ratioWidth );
  double get size146 => FetchPixels().getPixelHeight(146.0 * ratioWidth );
  double get size147 => FetchPixels().getPixelHeight(147.0 * ratioWidth );
  double get size148 => FetchPixels().getPixelHeight(148.0 * ratioWidth );
  double get size149 => FetchPixels().getPixelHeight(149.0 * ratioWidth );
  double get size150 => FetchPixels().getPixelHeight(150.0 * ratioWidth );
  double get size151 => FetchPixels().getPixelHeight(151.0 * ratioWidth );
  double get size152 => FetchPixels().getPixelHeight(152.0 * ratioWidth );
  double get size153 => FetchPixels().getPixelHeight(153.0 * ratioWidth );
  double get size154 => FetchPixels().getPixelHeight(154.0 * ratioWidth );
  double get size155 => FetchPixels().getPixelHeight(155.0 * ratioWidth );
  double get size156 => FetchPixels().getPixelHeight(156.0 * ratioWidth );
  double get size157 => FetchPixels().getPixelHeight(157.0 * ratioWidth );
  double get size158 => FetchPixels().getPixelHeight(158.0 * ratioWidth );
  double get size159 => FetchPixels().getPixelHeight(159.0 * ratioWidth );
  double get size160 => FetchPixels().getPixelHeight(160.0 * ratioWidth );
  double get size161 => FetchPixels().getPixelHeight(161.0 * ratioWidth );
  double get size162 => FetchPixels().getPixelHeight(162.0 * ratioWidth );
  double get size163 => FetchPixels().getPixelHeight(163.0 * ratioWidth );
  double get size164 => FetchPixels().getPixelHeight(164.0 * ratioWidth );
  double get size165 => FetchPixels().getPixelHeight(165.0 * ratioWidth );
  double get size166 => FetchPixels().getPixelHeight(166.0 * ratioWidth );
  double get size167 => FetchPixels().getPixelHeight(167.0 * ratioWidth );
  double get size168 => FetchPixels().getPixelHeight(168.0 * ratioWidth );
  double get size169 => FetchPixels().getPixelHeight(169.0 * ratioWidth );
  double get size170 => FetchPixels().getPixelHeight(170.0 * ratioWidth );
  double get size171 => FetchPixels().getPixelHeight(171.0 * ratioWidth );
  double get size172 => FetchPixels().getPixelHeight(172.0 * ratioWidth );
  double get size173 => FetchPixels().getPixelHeight(173.0 * ratioWidth );
  double get size174 => FetchPixels().getPixelHeight(174.0 * ratioWidth );
  double get size175 => FetchPixels().getPixelHeight(175.0 * ratioWidth );
  double get size176 => FetchPixels().getPixelHeight(176.0 * ratioWidth );
  double get size177 => FetchPixels().getPixelHeight(177.0 * ratioWidth );
  double get size178 => FetchPixels().getPixelHeight(178.0 * ratioWidth );
  double get size179 => FetchPixels().getPixelHeight(179.0 * ratioWidth );
  double get size180 => FetchPixels().getPixelHeight(180.0 * ratioWidth );
  double get size181 => FetchPixels().getPixelHeight(181.0 * ratioWidth );
  double get size182 => FetchPixels().getPixelHeight(182.0 * ratioWidth );
  double get size183 => FetchPixels().getPixelHeight(183.0 * ratioWidth );
  double get size184 => FetchPixels().getPixelHeight(184.0 * ratioWidth );
  double get size185 => FetchPixels().getPixelHeight(185.0 * ratioWidth );
  double get size186 => FetchPixels().getPixelHeight(186.0 * ratioWidth );
  double get size187 => FetchPixels().getPixelHeight(187.0 * ratioWidth );
  double get size188 => FetchPixels().getPixelHeight(188.0 * ratioWidth );
  double get size189 => FetchPixels().getPixelHeight(189.0 * ratioWidth );
  double get size190 => FetchPixels().getPixelHeight(190.0 * ratioWidth );
  double get size191 => FetchPixels().getPixelHeight(191.0 * ratioWidth );
  double get size192 => FetchPixels().getPixelHeight(192.0 * ratioWidth );
  double get size193 => FetchPixels().getPixelHeight(193.0 * ratioWidth );
  double get size194 => FetchPixels().getPixelHeight(194.0 * ratioWidth );
  double get size195 => FetchPixels().getPixelHeight(195.0 * ratioWidth );
  double get size196 => FetchPixels().getPixelHeight(196.0 * ratioWidth );
  double get size197 => FetchPixels().getPixelHeight(197.0 * ratioWidth );
  double get size198 => FetchPixels().getPixelHeight(198.0 * ratioWidth );
  double get size199 => FetchPixels().getPixelHeight(199.0 * ratioWidth );
  double get size200 => FetchPixels().getPixelHeight(200.0 * ratioWidth );
  double get size201 => FetchPixels().getPixelHeight(201.0 * ratioWidth );
  double get size202 => FetchPixels().getPixelHeight(202.0 * ratioWidth );
  double get size203 => FetchPixels().getPixelHeight(203.0 * ratioWidth );
  double get size204 => FetchPixels().getPixelHeight(204.0 * ratioWidth );
  double get size205 => FetchPixels().getPixelHeight(205.0 * ratioWidth );
  double get size206 => FetchPixels().getPixelHeight(206.0 * ratioWidth );
  double get size207 => FetchPixels().getPixelHeight(207.0 * ratioWidth );
  double get size208 => FetchPixels().getPixelHeight(208.0 * ratioWidth );
  double get size209 => FetchPixels().getPixelHeight(209.0 * ratioWidth );
  double get size210 => FetchPixels().getPixelHeight(210.0 * ratioWidth );
  double get size211 => FetchPixels().getPixelHeight(211.0 * ratioWidth );
  double get size212 => FetchPixels().getPixelHeight(212.0 * ratioWidth );
  double get size213 => FetchPixels().getPixelHeight(213.0 * ratioWidth );
  double get size214 => FetchPixels().getPixelHeight(214.0 * ratioWidth );
  double get size215 => FetchPixels().getPixelHeight(215.0 * ratioWidth );
  double get size216 => FetchPixels().getPixelHeight(216.0 * ratioWidth );
  double get size217 => FetchPixels().getPixelHeight(217.0 * ratioWidth );
  double get size218 => FetchPixels().getPixelHeight(218.0 * ratioWidth );
  double get size219 => FetchPixels().getPixelHeight(219.0 * ratioWidth );
  double get size220 => FetchPixels().getPixelHeight(220.0 * ratioWidth );
  double get size221 => FetchPixels().getPixelHeight(221.0 * ratioWidth );
  double get size222 => FetchPixels().getPixelHeight(222.0 * ratioWidth );
  double get size223 => FetchPixels().getPixelHeight(223.0 * ratioWidth );
  double get size224 => FetchPixels().getPixelHeight(224.0 * ratioWidth );
  double get size225 => FetchPixels().getPixelHeight(225.0 * ratioWidth );
  double get size226 => FetchPixels().getPixelHeight(226.0 * ratioWidth );
  double get size227 => FetchPixels().getPixelHeight(227.0 * ratioWidth );
  double get size228 => FetchPixels().getPixelHeight(228.0 * ratioWidth );
  double get size229 => FetchPixels().getPixelHeight(229.0 * ratioWidth );
  double get size230 => FetchPixels().getPixelHeight(230.0 * ratioWidth );
  double get size231 => FetchPixels().getPixelHeight(231.0 * ratioWidth );
  double get size232 => FetchPixels().getPixelHeight(232.0 * ratioWidth );
  double get size233 => FetchPixels().getPixelHeight(233.0 * ratioWidth );
  double get size234 => FetchPixels().getPixelHeight(234.0 * ratioWidth );
  double get size235 => FetchPixels().getPixelHeight(235.0 * ratioWidth );
  double get size236 => FetchPixels().getPixelHeight(236.0 * ratioWidth );
  double get size237 => FetchPixels().getPixelHeight(237.0 * ratioWidth );
  double get size238 => FetchPixels().getPixelHeight(238.0 * ratioWidth );
  double get size239 => FetchPixels().getPixelHeight(239.0 * ratioWidth );
  double get size240 => FetchPixels().getPixelHeight(240.0 * ratioWidth );
  double get size241 => FetchPixels().getPixelHeight(241.0 * ratioWidth );
  double get size242 => FetchPixels().getPixelHeight(242.0 * ratioWidth );
  double get size243 => FetchPixels().getPixelHeight(243.0 * ratioWidth );
  double get size244 => FetchPixels().getPixelHeight(244.0 * ratioWidth );
  double get size245 => FetchPixels().getPixelHeight(245.0 * ratioWidth );
  double get size246 => FetchPixels().getPixelHeight(246.0 * ratioWidth );
  double get size247 => FetchPixels().getPixelHeight(247.0 * ratioWidth );
  double get size248 => FetchPixels().getPixelHeight(248.0 * ratioWidth );
  double get size249 => FetchPixels().getPixelHeight(249.0 * ratioWidth );
  double get size250 => FetchPixels().getPixelHeight(250.0 * ratioWidth );
  double get size251 => FetchPixels().getPixelHeight(251.0 * ratioWidth );
  double get size252 => FetchPixels().getPixelHeight(252.0 * ratioWidth );
  double get size253 => FetchPixels().getPixelHeight(253.0 * ratioWidth );
  double get size254 => FetchPixels().getPixelHeight(254.0 * ratioWidth );
  double get size255 => FetchPixels().getPixelHeight(255.0 * ratioWidth );
  double get size256 => FetchPixels().getPixelHeight(256.0 * ratioWidth );
  double get size257 => FetchPixels().getPixelHeight(257.0 * ratioWidth );
  double get size258 => FetchPixels().getPixelHeight(258.0 * ratioWidth );
  double get size259 => FetchPixels().getPixelHeight(259.0 * ratioWidth );
  double get size260 => FetchPixels().getPixelHeight(260.0 * ratioWidth );
  double get size261 => FetchPixels().getPixelHeight(261.0 * ratioWidth );
  double get size262 => FetchPixels().getPixelHeight(262.0 * ratioWidth );
  double get size263 => FetchPixels().getPixelHeight(263.0 * ratioWidth );
  double get size264 => FetchPixels().getPixelHeight(264.0 * ratioWidth );
  double get size265 => FetchPixels().getPixelHeight(265.0 * ratioWidth );
  double get size266 => FetchPixels().getPixelHeight(266.0 * ratioWidth );
  double get size267 => FetchPixels().getPixelHeight(267.0 * ratioWidth );
  double get size268 => FetchPixels().getPixelHeight(268.0 * ratioWidth );
  double get size269 => FetchPixels().getPixelHeight(269.0 * ratioWidth );
  double get size270 => FetchPixels().getPixelHeight(270.0 * ratioWidth );
  double get size271 => FetchPixels().getPixelHeight(271.0 * ratioWidth );
  double get size272 => FetchPixels().getPixelHeight(272.0 * ratioWidth );
  double get size273 => FetchPixels().getPixelHeight(273.0 * ratioWidth );
  double get size274 => FetchPixels().getPixelHeight(274.0 * ratioWidth );
  double get size275 => FetchPixels().getPixelHeight(275.0 * ratioWidth );
  double get size276 => FetchPixels().getPixelHeight(276.0 * ratioWidth );
  double get size277 => FetchPixels().getPixelHeight(277.0 * ratioWidth );
  double get size278 => FetchPixels().getPixelHeight(278.0 * ratioWidth );
  double get size279 => FetchPixels().getPixelHeight(279.0 * ratioWidth );
  double get size280 => FetchPixels().getPixelHeight(280.0 * ratioWidth );
  double get size281 => FetchPixels().getPixelHeight(281.0 * ratioWidth );
  double get size282 => FetchPixels().getPixelHeight(282.0 * ratioWidth );
  double get size283 => FetchPixels().getPixelHeight(283.0 * ratioWidth );
  double get size284 => FetchPixels().getPixelHeight(284.0 * ratioWidth );
  double get size285 => FetchPixels().getPixelHeight(285.0 * ratioWidth );
  double get size286 => FetchPixels().getPixelHeight(286.0 * ratioWidth );
  double get size287 => FetchPixels().getPixelHeight(287.0 * ratioWidth );
  double get size288 => FetchPixels().getPixelHeight(288.0 * ratioWidth );
  double get size289 => FetchPixels().getPixelHeight(289.0 * ratioWidth );
  double get size290 => FetchPixels().getPixelHeight(290.0 * ratioWidth );
  double get size291 => FetchPixels().getPixelHeight(291.0 * ratioWidth );
  double get size292 => FetchPixels().getPixelHeight(292.0 * ratioWidth );
  double get size293 => FetchPixels().getPixelHeight(293.0 * ratioWidth );
  double get size294 => FetchPixels().getPixelHeight(294.0 * ratioWidth );
  double get size295 => FetchPixels().getPixelHeight(295.0 * ratioWidth );
  double get size296 => FetchPixels().getPixelHeight(296.0 * ratioWidth );
  double get size297 => FetchPixels().getPixelHeight(297.0 * ratioWidth );
  double get size298 => FetchPixels().getPixelHeight(298.0 * ratioWidth );
  double get size299 => FetchPixels().getPixelHeight(299.0 * ratioWidth );
  double get size300 => FetchPixels().getPixelHeight(300.0 * ratioWidth );
  double get size320 => FetchPixels().getPixelHeight(320.0 * ratioWidth );
  double get size340 => FetchPixels().getPixelHeight(340.0 * ratioWidth );
  double get size343 => FetchPixels().getPixelHeight(343.0 * ratioWidth );
  double get size350 => FetchPixels().getPixelHeight(350.0 * ratioWidth );
  double get size450 => FetchPixels().getPixelHeight(450.0 * ratioWidth );
  double get size400 => FetchPixels().getPixelHeight(400.0 * ratioWidth );
  double get size500 => FetchPixels().getPixelHeight(500.0 * ratioWidth );
  double get size600 => FetchPixels().getPixelHeight(600.0 * ratioWidth );
  double get size800 => FetchPixels().getPixelHeight(800.0 * ratioWidth );

  double get size417 => FetchPixels().getPixelHeight(417.0 * ratioWidth );
  double get size1280 => FetchPixels().getPixelHeight(1280.0 * ratioWidth );
  double get size1600 => FetchPixels().getPixelHeight(1600.0 * ratioWidth );
  

}
