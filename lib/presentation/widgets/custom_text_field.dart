// File: lib/presentation/widgets/custom_text_field.dart
// Description: This file contains a custom text field widget used throughout the application.

import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final IconData? icon;
  final FocusNode? focusNode;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.controller,
    this.icon,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        suffixIcon: Icon(
          icon,
          color: AppColor.whiteColor50,
        ),
        labelText: hintText,
        labelStyle: TextStyle(color: AppColor.whiteColor50),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(
            color: AppColor.whiteColor50,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(
            color: AppColor.whiteColor50,
            width: 2.0,
          ),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
