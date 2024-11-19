import 'package:flutter/material.dart';
import 'package:stapes_home/core/theme/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final IconData? icon;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.icon,
    this.focusNode,
    this.keyboardType,
  });

  @override
  createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        suffixIcon: Icon(
          widget.icon,
          color: AppColor.whiteColor50,
        ),
        // filled: true,
        // fillColor: const Color(0xFF161622),
        labelText: widget.hintText,
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
