import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppPadding {
  static EdgeInsetsGeometry pagePadding(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return EdgeInsets.symmetric(horizontal: screenSize.width * 0.03.w, vertical: screenSize.height * 0.05.h);
  }
}
