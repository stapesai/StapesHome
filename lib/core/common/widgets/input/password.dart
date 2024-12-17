import 'package:flutter/material.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:flutter/services.dart';

class CustomPasswordTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final IconData? icon;

  const CustomPasswordTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.icon,
  });

  @override
  createState() => _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: AppColor.whiteColor,
      controller: widget.controller,
      obscureText: _obscureText,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r"\s")),
      ],
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
