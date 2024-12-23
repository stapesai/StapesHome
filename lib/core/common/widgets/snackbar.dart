import 'package:flutter/material.dart';

enum SnackbarType { info, success, error }

class CustomSnackbar {
  static const Map<SnackbarType, Color> snackbarColors = {
    SnackbarType.info: Colors.blue,
    SnackbarType.success: Colors.green,
    SnackbarType.error: Colors.red,
  };

  CustomSnackbar(BuildContext context, String message, {
    SnackbarType type = SnackbarType.info, 
    int? duration = 2
  }) {
    showSnackBar(context, message, type: type, duration: duration);
  }

  static void showSnackBar(BuildContext context, String message, {
    SnackbarType? type, 
    int? duration
  }) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: snackbarColors[type],
      duration: Duration(seconds: duration ?? 2),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10),
      dismissDirection: DismissDirection.vertical,
      showCloseIcon: true,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      animation: Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).animate(
        CurvedAnimation(
          parent: AnimationController(
            vsync: ScaffoldMessenger.of(context),
            duration: const Duration(milliseconds: 500),
          )..forward(),
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}