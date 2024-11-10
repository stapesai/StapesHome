// Path: lib/data/models/auth/login_req_parms.dart
// Description: This file contains models for the login related requests.

class RequestLoginParams {
  final String email;
  final String password;

  RequestLoginParams({
    required this.email,
    required this.password,
  });

  Map<String, String> toJson() {
    return {
      'email': email,
      'password': password,
    };
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
      transactionId: json['transactionId'],
      otpExpiresAt: json['otpExpiresAt'],
    );
  }
}

class CompleteLoginParams {
  final String transactionId;

  CompleteLoginParams({
    required this.transactionId,
  });

  Map<String, String> toJson() {
    return {
      'transactionId': transactionId,
    };
  }
}

class CompleteLoginResponse {
  
}
