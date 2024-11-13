import 'dart:convert';
import 'package:stapes_home/features/auth/data/models/user_model.dart';
import 'package:stapes_home/features/auth/data/models/user_session_model.dart';

class RequestSignUpParams {
  final String email;

  RequestSignUpParams({
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
  final DateTime otpExpiresAt;

  RequestSignUpResponse({
    required this.detail,
    required this.transactionId,
    required this.otpExpiresAt,
  });

  factory RequestSignUpResponse.fromJson(Map<String, dynamic> response) {
    return RequestSignUpResponse(
      detail: response['detail'],
      transactionId: response['transaction_id'],
      otpExpiresAt: DateTime.parse(response['otp_expires_at']),
    );
  }
}

class CompleteSignUpParams {
  final String transactionId;
  final UserModel user;
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
  final UserSessionModel session;
  final UserModel user;

  CompleteSignUpResponse({
    required this.detail,
    required this.session,
    required this.user,
  });

  factory CompleteSignUpResponse.fromJson(Map<String, dynamic> response) {
    return CompleteSignUpResponse(
      detail: response['detail'],
      session: UserSessionModel.fromJson(response['session']),
      user: UserModel.fromJson(response['user']),
    );
  }
}
