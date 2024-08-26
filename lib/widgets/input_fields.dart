import 'package:flutter/material.dart';
import 'package:jarvis/constants/colors.dart';

class NTextField extends StatefulWidget {
  final String hintText;

  final TextEditingController? controller;
  final IconData? icon;

  const NTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.icon,
  });

  @override
  createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<NTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
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

class PasswordTextField extends StatefulWidget {
  final String hintText;
  final bool obscureText = true;
  final TextEditingController? controller;
  final IconData? icon;

  PasswordTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.icon,
  });

  @override
  createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      inputFormatters: [
        // FilteringTextInputFormatter.allow(RegExp(
        //     r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$%\^&\*])[A-Za-z\d!@#\$%\^&\*]{8,}$')),
      ],
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
