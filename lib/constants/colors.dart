import 'package:flutter/material.dart';

class AppColor {
  AppColor._();
  static const Color whiteColor = Colors.white;
  static Color whiteColor50 = Colors.white.withOpacity(0.5);
  static const Color textHyperlinkColor = Color(0xFF0085FF);
  static const Color primaryColor = Color(0xFF353841);
  static const Color primaryColorLight = Color(0XFF898989);
  static const Color secondaryColor = Color(0xFF141414);
  static const Color containerColor = Color(0xFF28282F);
  static const Color iconBarColor = Color.fromARGB(152, 255, 160, 28);
  static const backgroundColorgradient = LinearGradient(
      begin: Alignment(0.00, -1.00), end: Alignment(0, 1), colors: [Color(0xFF353841), Color(0xFF141414)]);

  static const Color themecolor = Color(0XFFC2F656);

  // Debug Colors
  // static const Color whiteColor = Color.fromARGB(255, 255, 0, 0);
  // static Color whiteColor50 = const Color.fromARGB(255, 255, 0, 0);
}
