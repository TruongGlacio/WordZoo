
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wordzoo/base/button/action_button1.dart';
import 'package:wordzoo/base/theme/colors_app.dart';
import 'package:wordzoo/base/theme/text_stype_constant.dart';
import 'package:wordzoo/generated/l10n.dart';
import 'package:wordzoo/base/resizer/size_manager.dart';

import 'common_dialog1.dart';
class ConfirmPopupPage extends StatefulWidget{
  void show(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => this);
  }
  void Function()? onAccept, onCancel;
  String? title;
  String? content;
  TextAlign? contentTextAlign;
  MainAxisAlignment? titleAlignment;
  MainAxisAlignment?contentAlignment;
  bool ?enableCancelButton;
  TextStyle? contentStyle;
  String? acceptButtonText;
  String? cancelButtonText;
  Color?acceptButtonColor, cancelButtonColor;
  ConfirmPopupPage({
    super.key, this.onAccept, this.onCancel, this.enableCancelButton,
    this.acceptButtonColor, this.cancelButtonColor,
    this.acceptButtonText, this.cancelButtonText,this.contentTextAlign,this.contentAlignment, this.titleAlignment,
    this.content, this.title, this.contentStyle});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ConfirmPopupPageState();
  }

}
class ConfirmPopupPageState extends State<ConfirmPopupPage> with SingleTickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    bool  isTablet = false;
    return buildUiAll(context, isTablet: isTablet);
  }
  late AnimationController controller ;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  Widget buildUiAll(BuildContext context, {bool ? isTablet}){
    isTablet??=false;
    
    return ScaleTransition(
      scale: scaleAnimation,
      child: CustomDialog1(
          title: widget.title,
          titleAlignment:widget.titleAlignment??MainAxisAlignment.start,
          titleStyle: TextStyleConstant.h6.copyWith(color: ColorConst.neutralDarker),
          insetPadding: EdgeInsets.zero,
          width: MediaQuery.of(context).size.width*(!isTablet?0.95: 0.7),
          enableBackButton: false,
          enableCloseButton: true,
          mainAxisSizeParent: MainAxisSize.min,
          bodyBackGroundColor: ColorConst.whiteColor,
          headerColor: ColorConst.whiteColor,
          child: Column(
            children: [
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: Dimens().paddingMedium, vertical: Dimens().paddingMedium),
                child: Center(
                  child: Row(
                    mainAxisAlignment: widget.contentAlignment??MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                            widget.content??"",
                            textAlign: TextAlign.start,
                            style: widget.contentStyle??TextStyleConstant.body2.copyWith(color: ColorConst.neutralDarker),
                        ),
                      ),
                    ],
                  ),),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: widget.enableCancelButton??true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ActionButton1(
                              width: Dimens().size150,
                              enableBgColor: widget.cancelButtonColor??ColorConst.whiteColor,
                              borderColor:  ColorConst.neutralLight,

                              onTap: () async {
                                Navigator.of(context).pop();
                                if(widget.onCancel!=null)
                                {
                                  widget.onCancel!();
                                }
                              },
                              text: widget.cancelButtonText??S().str_cancel,
                            textStype: TextStyleConstant.button1.copyWith(color: ColorConst.neutralDark),
                          )
                          ,
                          Gap(Dimens().size20),
                        ],
                      ),
                    ),

                    ActionButton1(
                        width: Dimens().size150,
                      enableBgColor: widget.acceptButtonColor??ColorConst.primary,
                      onTap: () async {
                          Navigator.of(context).pop();
                          if(widget.onAccept!=null)
                            {
                              widget.onAccept!();
                            }
                        },
                        text: widget.acceptButtonText??S().str_accept,
                    ),
                  ],
                ),
              )
            ],
          )
      ),
    );
  }
  }