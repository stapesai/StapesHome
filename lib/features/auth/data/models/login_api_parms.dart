// Path: lib/data/models/auth/login_req_parms.dart
// Description: This file contains models for the login related requests.

import 'dart:convert';

class RequestLoginParams {
  final String email;
  final String password;

  RequestLoginParams({
    required this.email,
    required this.password,
  });

  Object toJson() {
    return jsonEncode({
      'email': email,
      'password': password,
    });
  }
}

class RequestLoginResponse {
  final String detail;
  final String transactionId;
  final String otpExpiresAt;

  RequestLoginResponse({
    required this.detail,
    required this.transactionId,
    required this.otpExpiresAt,
  });

  factory RequestLoginResponse.fromJson(Map<String, dynamic> json) {
    return RequestLoginResponse(
      detail: json['detail'],
      transactionId: json['transaction_id'],
      otpExpiresAt: json['otp_expires_at'],
    );
  }
}

class CompleteLoginParams {
  final String transactionId;

  CompleteLoginParams({
    required this.transactionId,
  });

  Object toJson() {
    return jsonEncode({
      'transaction_id': transactionId,
    });
  }
}

class CompleteLoginResponse {
  final String sessionId;
  final String userId;
  final String createdAt;
  final String lastActiveAt;

  CompleteLoginResponse({
    required this.sessionId,
    required this.userId,
    required this.createdAt,
    required this.lastActiveAt,
  });

  factory CompleteLoginResponse.fromJson(Map<String, dynamic> json) {
    return CompleteLoginResponse(
      // TODO: @gauransh415 ye change hoga useraur session model ke hisab se
      sessionId: json['session']['session_id'],
      userId: json['session']['user_id'],
      createdAt: json['session']['created_at'],
      lastActiveAt: json['session']['last_active_at'],
    );
  }
}
