// otp_input_widget.dart

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:stapes_home/core/theme/app_font_sizes.dart';
import 'package:stapes_home/core/theme/app_colors.dart';

class OtpInputWidget extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final Function(String) onOtpComplete;

  const OtpInputWidget({
    super.key,
    required this.controllers,
    required this.focusNodes,
    required this.onOtpComplete,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = OtpTheme.defaultTheme(context);
    final focusedPinTheme = OtpTheme.focusedTheme(context);

    return Pinput(
      length: 6,
      showCursor: false,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      focusNode: focusNodes[0],
      controller: controllers[0],
      onCompleted: onOtpComplete,
      onChanged: (String value) {
        if (value.length == 1) {
          focusNodes[1].requestFocus();
        }
      },
    );
  }
}

class OtpTheme {
  static PinTheme defaultTheme(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: AppFontSizes.pageSubHeading,
        color: AppColor.whiteColor,
        fontWeight: FontWeight.w600
      ),
      margin: EdgeInsets.symmetric(
        horizontal: screenSize.width > 640 ? 12 : 2
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.00, -1.00),
          end: Alignment(0, 1),
          colors: [Color(0xFF292B30), Color(0xFF26272C), Color(0xFF1A1B1E)],
        ),
      ),
    );
  }

  static PinTheme focusedTheme(BuildContext context) {
    return defaultTheme(context).copyDecorationWith(
      border: Border.all(color: AppColor.whiteColor, width: 2),
    );
  }
}