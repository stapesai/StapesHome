// File: lib/core/constants/padding.dart
// Description: This file contains padding constants used throughout the application.

import 'package:flutter/material.dart';

class AppPadding {
  static EdgeInsetsGeometry pagePadding(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return EdgeInsets.symmetric(horizontal: screenSize.width * 0.05);
  }
}
