import 'dart:convert';

import 'package:stapes_home/features/auth/data/models/user_model.dart';
import 'package:stapes_home/features/auth/data/models/user_session_model.dart';

class RequestSignupParams {
  final String email;

  RequestSignupParams({
    required this.email,
  });

  Object toJson() {
    return jsonEncode({
      'email': email,
    });
  }
}

class RequestSignUpResponse {
  final String detail;
  final String transactionId;
  final String otpExpiresAt;

  RequestSignUpResponse({
    required this.detail,
    required this.transactionId,
    required this.otpExpiresAt,
  });

  factory RequestSignUpResponse.fromJson(Map<String, dynamic> json) {
    return RequestSignUpResponse(
      detail: json['detail'],
      transactionId: json['transaction_id'],
      otpExpiresAt: json['otp_expires_at'],
    );
  }
}

class CompleteSignUpParams {
  final String transactionId;
  final User user;
  final String password;

  CompleteSignUpParams({
    required this.transactionId,
    required this.user,
    required this.password,
  });

  Object toJson() {
    return jsonEncode({
      'transaction_id': transactionId,
      'user': user.toJson(),
      'password': password,
    });
  }
}

class CompleteSignUpResponse {
  final String detail;
  final UserSession session;
  final User user;

  CompleteSignUpResponse({
    required this.detail,
    required this.session,
    required this.user,
  });

  factory CompleteSignUpResponse.fromJson(Map<String, dynamic> json) {
    return CompleteSignUpResponse(
      detail: json['detail'],
      session: UserSession.fromJson(json['session']),
      user: User.fromJson(json['user']),
    );
  }
}
