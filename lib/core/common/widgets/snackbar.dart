import 'package:flutter/material.dart';

enum SnackbarType { info, success, error }

class CustomSnackbar {
  static const Map<SnackbarType, Color> snackbarColors = {
    SnackbarType.info: Colors.blue,
    SnackbarType.success: Colors.green,
    SnackbarType.error: Colors.red,
  };

  // Constructor that directly shows the Snackbar
  CustomSnackbar(BuildContext context, String message, {SnackbarType type = SnackbarType.info, int? duration = 2}) {
    showSnackBar(context, message, type: type, duration: duration);
  }

  static void showSnackBar(BuildContext context, String message, {SnackbarType? type, int? duration}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: snackbarColors[type],
      duration: Duration(seconds: duration!),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
