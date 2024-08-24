import 'package:flutter/material.dart';
import 'package:jarvis/constants/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColor.iconBarColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: 364,
      // add icon if it is not null
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LogoutButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 45, // Diameter of the circle
        height: 45,
        decoration: BoxDecoration(
          color: Colors
              .transparent, // Outer circle color (you can adjust the opacity)
          shape: BoxShape.circle,
          border: Border.all(
            color: Color(0xFFE2FC2B), // Green color for the border
            width: 3, // Border width
          ),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 25,

            // Icon inside the button
            color: Color(0xFFE2FC2B), // Icon color (green)
          ),
        ),
      ),
    );
  }
}
