// File: lib/presentation/widgets/password_text_field.dart
// Description: This file contains a custom password text field widget used throughout the application.

import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class PasswordTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const PasswordTextField({
    Key? key,
    required this.hintText,
    this.controller,
    this.focusNode,
  }) : super(key: key);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: _obscureText,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: AppColor.whiteColor50,
          ),
          onPressed: _togglePasswordVisibility,
        ),
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
