import 'package:flutter/material.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
 
 class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final IconData? icon;

  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.icon,

    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,

      keyboardType: keyboardType,
      cursorColor: AppColor.whiteColor,
      decoration: InputDecoration(
        suffixIcon: Icon(icon, color: AppColor.whiteColor50),
        labelText: hintText,
        labelStyle: TextStyle(color: AppColor.whiteColor50),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: AppColor.whiteColor50, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: AppColor.whiteColor50, width: 2.0),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
