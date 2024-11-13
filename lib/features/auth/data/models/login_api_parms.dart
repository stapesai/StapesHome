// Path: lib/data/models/auth/login_req_parms.dart
// Description: This file contains models for the login related requests.

import 'dart:convert';

import 'package:stapes_home/features/auth/data/models/user_model.dart';
import 'package:stapes_home/features/auth/data/models/user_session_model.dart';

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
  final DateTime otpExpiresAt;

  RequestLoginResponse({
    required this.detail,
    required this.transactionId,
    required this.otpExpiresAt,
  });

  factory RequestLoginResponse.fromJson(Map<String, dynamic> response) {
    return RequestLoginResponse(
      detail: response['detail'],
      transactionId: response['transaction_id'],
      otpExpiresAt: DateTime.parse(response['otp_expires_at']),
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
  final UserModel user;
  final UserSessionModel session;

  CompleteLoginResponse({
    required this.session,
    required this.user,
  });

  factory CompleteLoginResponse.fromJson(Map<String, dynamic> response) {
    return CompleteLoginResponse(
      user: UserModel.fromJson(response['user']),
      session: UserSessionModel.fromJson(response['session']),
    );
  }
}
