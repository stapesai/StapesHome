import 'package:flutter/material.dart';

class AppPadding {
  static EdgeInsetsGeometry pagePadding(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return EdgeInsets.symmetric(horizontal: screenSize.width * 0.00);
  }
}
