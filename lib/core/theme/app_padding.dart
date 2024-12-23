import 'package:flutter/material.dart';

class AppPadding {
  static EdgeInsetsGeometry pagePadding(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    // Calculate padding values
    final horizontalPadding = screenSize.width * 0.06;
    final verticalPadding = screenSize.height * 0.04;
    
    return EdgeInsets.symmetric(
      horizontal: horizontalPadding,
      vertical: verticalPadding,
    );
  }
}