// Path: lib/data/models/auth/forgot_password_parms.dart
// Description: This file contains models for the forgot password related requests.

import 'dart:convert';

class RequestPasswordResetParams {
  final String email;

  RequestPasswordResetParams({
    required this.email,
  });

  Object toJson() {
    return jsonEncode({
      'email': email,
    });
  }
}

class RequestPasswordResetResponse {
  final String detail;
  final String transactionId;
  final DateTime otpExpiresAt;

  RequestPasswordResetResponse({
    required this.detail,
    required this.transactionId,
    required this.otpExpiresAt,
  });

  factory RequestPasswordResetResponse.fromJson(Map<String, dynamic> response) {
    return RequestPasswordResetResponse(
      detail: response['detail'],
      transactionId: response['transaction_id'],
      otpExpiresAt: response['otp_expires_at'],
    );
  }
}

class CompletePasswordResetParams {
  final String email;
  final String password;
  final String transactionId;

  CompletePasswordResetParams({
    required this.email,
    required this.password,
    required this.transactionId,
  });

  Object toJson() {
    return jsonEncode({
      'email': email,
      'password': password,
      'transaction_id': transactionId,
    });
  }
}

class CompletePasswordResetResponse {
  final String detail;

  CompletePasswordResetResponse({
    required this.detail,
  });

  factory CompletePasswordResetResponse.fromJson(Map<String, dynamic> response) {
    return CompletePasswordResetResponse(
      detail: response['detail'],
    );
  }
}
