import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:wordzoo/base/theme/colors_app.dart';
import 'package:wordzoo/base/theme/text_stype_constant.dart';
import 'package:wordzoo/base/widgets/dialog_common/stateless_widget_common.dart';
import 'package:wordzoo/base/resizer/size_manager.dart';

class CustomDialog1 extends StatelessWidgetCommon{
  /// This [CustomDialog1] show app dialog common
  CustomDialog1(
      {
        super.key,
        required this.child,
        this.height,
        this.width,
        this.radius,
        this.insetPadding,
        this.enableCloseButton,
        this.enableBackButton,
        this.title,
        this.canBackdrop = true,
        this.enableHeader= true,
        this.alignment,
        this.mainAxisSizeParent,
        this.titleIcon,
        this.bodyBackGroundColor,
        this.backButtonCallback,
        this.titleAlignment,
        this.titleStyle,
        this.enableHeaderDivider,
        this.headerColor,
        this.borderColor,
        this.headerIconColor,
        this.scrollController,
        this.maxHeight
      }){
    title??="";
    bodyBackGroundColor??=ColorConst.white;
    enableCloseButton??=true;
    enableBackButton??=false;
    radius??=Dimens().borderRadiusMedium;
    enableHeader??=true;
    alignment??=Alignment.center;
    mainAxisSizeParent ??=MainAxisSize.max;
    enableHeaderDivider??=false;
    scrollController??= ScrollController();
  }

  ///constant width dynamic
  static const double dynamicSize = -1;

  /// content dialog;
  final Widget child;
  final Widget? titleIcon;
  TextStyle? titleStyle;
  bool? enableCloseButton;
  bool? enableBackButton;
  String? title;
  bool ? enableHeader;
  Color? bodyBackGroundColor;
  Color? headerColor;
  Color? borderColor;
  Color? headerIconColor;


  AlignmentGeometry? alignment;
  MainAxisAlignment? titleAlignment;
  /// radius dialog;
  double? radius;
  final EdgeInsets? insetPadding;
  /// The [height] height of dialog
  final double? height;
  final double? maxHeight;

  Function()?backButtonCallback;
  ScrollController? scrollController = ScrollController();
  ///The [width] width of dialog
  ///
  /// If [width] is null width default is device screen width DeviceUtils.isTablet() ? size.width * 0.4 : size.width * 0.95
  final double? width;
  MainAxisSize? mainAxisSizeParent;
  final bool canBackdrop;
  bool? enableHeaderDivider;

  ///The [show] function show custom dialog
  void show(BuildContext context) {
    showDialog(
        barrierDismissible: canBackdrop,
        context: context,
        useSafeArea: false,
        builder: (context) => this).then((value) {
         // ToastUtils.dismiss();
    },);
  }

  @override
  Widget rootWidget(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final breakpoint = ResponsiveBreakpoints.of(context);

    bool isTablet = breakpoint.isTablet;
    double? widthSize = width ?? (isTablet ? size.width * 0.7 : size.width * 0.95);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: null,
      resizeToAvoidBottomInset: false,
      body: InkWell(
        onTap: (){
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          /// boc de thuc hien ontap outside
          height:MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(radius!,),
          ),
          constraints: BoxConstraints(
            maxHeight:  MediaQuery.sizeOf(context).height,
            maxWidth: MediaQuery.sizeOf(context).width,
          ),
          child: Dialog(
            insetPadding: insetPadding ??  EdgeInsets.symmetric(horizontal: Dimens().spacing8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius!)),
            alignment: alignment!,
            child: Container(
                  width: widthSize,
                  decoration: BoxDecoration(
                    color: bodyBackGroundColor,
                    borderRadius: BorderRadius.circular(radius!,),
                  ),
                  padding: EdgeInsets.only(bottom: radius??0),
                  constraints:  BoxConstraints(
                    minWidth: 12,
                    minHeight: MediaQuery.of(context).size.height* 1/5,
                    maxHeight: maxHeight??MediaQuery.of(context).size.height* 0.95,
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: enableHeader!,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                               // height: isTablet?Dimens().size60:Dimens().size50,
                                decoration: BoxDecoration(
                                  color: headerColor??ColorConst.primaryColor,
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(radius!)),
                                ),
                                child: SafeArea(
                                  bottom: false,
                                  child: Padding(
                                    padding:  EdgeInsets.symmetric(horizontal: Dimens().paddingMedium, vertical: Dimens().paddingLarge),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Visibility(
                                          visible: enableBackButton??false,
                                          child: InkWell(
                                              onTap: (){
                                                if(enableBackButton!)
                                                  {
                                                    if(backButtonCallback!=null)
                                                      {
                                                        backButtonCallback!();
                                                      }
                                                    else
                                                      {
                                                        Navigator.of(context).pop();
                                                      }
                                                  }
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                                child: Icon(
                                                  Icons.arrow_back_ios_rounded,
                                                  size: Dimens().size20,
                                                  color: enableBackButton!?(headerIconColor??ColorConst.white):Colors.transparent,
                                                ),
                                              )),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: titleAlignment??MainAxisAlignment.start,
                                            children: [
                                              titleIcon??const SizedBox.shrink(),
                                              Gap(Dimens().size5),
                                              Expanded(
                                                child: Text(
                                                    title!,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: titleStyle??TextStyleConstant.h4.copyWith(color: ColorConst.white)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        enableCloseButton!?
                                        InkWell(
                                            onTap: (){
                                              Navigator.of(context).pop();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: Icon(
                                                Icons.close,
                                                size: Dimens().size20,
                                                color: enableCloseButton!?(headerIconColor??ColorConst.whiteColor):Colors.transparent,
                                              ),
                                            )):
                                        SizedBox(width: Dimens().size20,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: enableHeaderDivider??false,
                                child: Divider(
                                  color: ColorConst.greyColor1,
                                  height: 1,
                                ),
                              )
                            ],
                          ),
                        ),
                        Visibility(
                          visible: true, //mainAxisSizeParent==MainAxisSize.min,
                          child: Container(
                            decoration: BoxDecoration(
                                color: bodyBackGroundColor,
                                borderRadius: BorderRadius.vertical(bottom: Radius.circular(radius!)),
                                border: BoxBorder.fromLTRB(
                                  left: BorderSide(color:borderColor??Colors.transparent ),
                                  right:  BorderSide(color:borderColor??Colors.transparent ),
                                  bottom: BorderSide(color:borderColor??Colors.transparent )
                            )

                            ),
                            padding: EdgeInsets.only(bottom: Dimens().size16),
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  child,
                                ],
                              ),
                            )),
                        ),
                       /* Visibility(
                          visible: mainAxisSizeParent==MainAxisSize.max,
                          child: Expanded(
                            child: Container(
                                decoration: BoxDecoration(
                                    color: bodyBackGroundColor,
                                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(radius!)),
                                    border: BoxBorder.fromLTRB(
                                        left: BorderSide(color:borderColor??Colors.transparent ),
                                        right:  BorderSide(color:borderColor??Colors.transparent ),
                                        bottom: BorderSide(color:borderColor??Colors.transparent )
                                    )
                                    //border: const Border(bottom: BorderSide(color: Colors.white), right: BorderSide(color: Colors.white), left: BorderSide(color: Colors.white))
                                ),
                                child: Column(
                                  children: [
                                    child,
                                  ],
                                )),
                          ),
                        ),*/
                      ],
                    ),
                  )
                ),
          ),
        ),
      ),
    );
  }
}
