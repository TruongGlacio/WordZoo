import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
class FetchPixels {

  FetchPixels._();

  static final FetchPixels instance = FetchPixels._();
  factory FetchPixels() => instance;
   double mockupWidth = 888 ;
   double mockupHeight = 390;
   double width = 0;
   double height = 0;
   late BuildContext _context ;
   late ResponsiveBreakpointsData breakpoint;
  void setFetchPixels(BuildContext context) {
    _context = context;
     breakpoint = ResponsiveBreakpoints.of(context);
     width = MediaQuery.of(context).size.width;
     height = MediaQuery.of(context).size.height;
  }

   double getHeightPercentSize(double percent) {
    return (percent * height) / 100;
  }

   double getWidthPercentSize(double percent) {
    return (percent * width) / 100;
  }

   double getPixelWidth(double val) {
    return val / mockupWidth * width;
  }

   double getPixelHeight(double val) {
    return val; //val / mockupHeight * height;
  }

   double getTextScale() {

    double textScaleFactor = (width > height) ? width / mockupWidth : height / mockupHeight;
    final breakpoint = ResponsiveBreakpoints.of(_context);

    if (breakpoint.isTablet) {
      textScaleFactor = height / mockupHeight;
    }

    return textScaleFactor;
  }

   double getScale(t) {
    double scale =
        (width > height) ? mockupWidth / width : mockupHeight / height;
    final breakpoint = ResponsiveBreakpoints.of(_context);

    if (breakpoint.isTablet) {
      scale = height / mockupHeight;
    }

    return scale;
  }
}
