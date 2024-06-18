// lib/Widgets/CustomTextField.dart

import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool obscureText;

  const CustomTextField({required this.hintText, this.obscureText = false});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white24,
        labelText: widget.hintText,
        labelStyle: const TextStyle(color: Color(0xFFFF9F1C)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(
            color: Color(0xFFFF9F1C),
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(
            color: Color(0xFFFF9F1C),
            width: 2.0,
          ),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
