import 'package:flutter/material.dart';
import 'package:wordzoo/base/theme/colors_app.dart';
import 'package:wordzoo/base/theme/text_stype_constant.dart';
import 'package:wordzoo/base/widgets/common/responsive_info.dart';
import 'package:wordzoo/base/resizer/size_manager.dart';

class ActionButton1 extends StatelessWidget {
  Color? enableBgColor;
  Color? disableBgColor;

  Color? borderColor;
  double? borderWidth;
  TextStyle? textStype;
  String? text;
  double? radius;
  Function()? onTap;
  double? width;
  double? height;
  bool? enable;
  bool? enableLinearColor;
  EdgeInsetsGeometry? contentPadding;
  double? elevation;
  Color? splashColor;
  ActionButton1(
      {super.key,
      this.enableBgColor,
        this.disableBgColor,
      this.text,
      this.textStype,
      this.radius,
      this.onTap,
      this.width,
      this.height, 
      this.borderColor,
        this.borderWidth,
        this.enableLinearColor,
        this.contentPadding,
        this.elevation,
        this.splashColor,
      this.enable}) {
    enableBgColor ??= ColorConst.buttonBgColor;
    textStype ??= TextStyleConstant.button1.copyWith(color: Colors.white);
    radius ??= Dimens().size8;
    height ??= ResponsiveInfo.isTablet() ?Dimens().size64:Dimens().size48;
    enable ??= true;
    enableLinearColor??=false;
    text??="";
    elevation??=1;
  }
  @override
  Widget build(BuildContext context) {
// TODO: implement build
    return Material(
      color: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      borderRadius:BorderRadius.all(Radius.circular(radius??Dimens().radiusSmall)),
      child: InkWell(
        onTap: () {
          if (onTap != null && enable!) {
            onTap!();
          }
        },
        splashColor: splashColor,
        highlightColor: splashColor,
        child: Card(
          elevation: elevation,
          color: enable! ? enableBgColor : (disableBgColor??enableBgColor!.withOpacity(0.3)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius??Dimens().radiusSmall)),
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius??Dimens().radiusSmall),
                border: Border.all(color: borderColor??Colors.transparent),
                shape: BoxShape.rectangle,
                gradient:(enableLinearColor??false)?
                LinearGradient(begin: Alignment.centerLeft,
                  stops: const [
                    0,
                    0.6,
                    1
                  ],
                  colors: [
                  ColorConst.colorLinear1,
                  ColorConst.colorLinear2,
                  ColorConst.colorLinear3
                  ]):null,
                color: enable! ? enableBgColor :  (disableBgColor??enableBgColor!.withOpacity(0.3)),
              ),
              child: Padding(
                padding: contentPadding??EdgeInsets.symmetric(vertical: Dimens().size4, horizontal: Dimens().size8),
                child: Center(
                  child: Text(
                    text!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: enable! ?textStype:textStype,
                  ),
                ),
              ),
            ),
          ),
      ),
    );
  }
}
