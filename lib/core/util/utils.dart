// File: lib/core/util/utils.dart
// Description: This file contains utility functions used throughout the application.

import 'dart:math';
import 'package:intl/intl.dart';

/// A collection of utility functions used across the application
class Utils {
  /// Formats a DateTime object to a string in the format "dd MMM yyyy"
  ///
  /// Parameters:
  /// - date: The DateTime object to format
  ///
  /// Returns:
  /// A formatted date string
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// Formats a DateTime object to a string in the format "HH:mm"
  ///
  /// Parameters:
  /// - time: The DateTime object to format
  ///
  /// Returns:
  /// A formatted time string
  // static String formatTime(DateTime time) {
  //   return DateFormat('HH:mm').format(time);
  // }

  /// Capitalizes the first letter of a given string
  ///
  /// Parameters:
  /// - str: The input string
  ///
  /// Returns:
  /// The input string with the first letter capitalized
  // static String capitalizeFirstLetter(String str) {
  //   if (str.isEmpty) return str;
  //   return str[0].toUpperCase() + str.substring(1);
  // }

  /// Truncates a string to a specified length and adds an ellipsis if necessary
  ///
  /// Parameters:
  /// - str: The input string
  /// - maxLength: The maximum length of the resulting string
  ///
  /// Returns:
  /// The truncated string
  // static String truncateString(String str, int maxLength) {
  //   if (str.length <= maxLength) return str;
  //   return '${str.substring(0, maxLength - 3)}...';
  // }

  /// Validates an email address using a simple regex pattern
  ///
  /// Parameters:
  /// - email: The email address to validate
  ///
  /// Returns:
  /// True if the email is valid, false otherwise
  // static bool isValidEmail(String email) {
  //   // TODO: Replace this with API based email validation
  //   final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  //   return emailRegex.hasMatch(email);
  // }

  /// Generates a random string of specified length
  ///
  /// Parameters:
  /// - length: The desired length of the random string
  ///
  /// Returns:
  /// A random string of the specified length
  // static String generateRandomString(int length) {
  //   const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  //   final random = Random();
  //   return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  // }

  /// Delays execution for a specified duration
  ///
  /// Parameters:
  /// - milliseconds: The number of milliseconds to delay
  ///
  /// Returns:
  /// A Future that completes after the specified duration
  static Future<void> delay(int milliseconds) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }
}
