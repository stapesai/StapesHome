// File: lib/presentation/widgets/custom_button.dart
// Description: This file contains a custom button widget used throughout the application.

import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColor.iconBarColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
            color: AppColor.whiteColor,
          ),
        ),
      ),
    );
  }
}
