import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller; // Add controller parameter
  final IconData? icon;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.obscureText = false,
    this.controller,
    this.icon,
  });

  @override
  createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller, // Use the controller
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        suffixIcon: Icon(
          widget.icon,
          color: const Color(0xFFFF9F1C),
        ),
        filled: true,
        fillColor: const Color(0xFF161622),
        labelText: widget.hintText,
        labelStyle: const TextStyle(color: Color(0xFFFF9F1C)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xFFFF9F1C),
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Color(0xFFFF9F1C),
            width: 2.0,
          ),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
