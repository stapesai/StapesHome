import 'package:flutter/material.dart';
import 'package:stapes_home/core/theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color backgroundColor = AppColor.iconBarColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54, // Fixed height
      width: double.infinity, // Takes maximum available width
      child: ElevatedButton(
        // if isLoading is true, onPressed will be null
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(AppColor.whiteColor),
              )
            : Text(
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
