// Path: lib/data/models/auth/otp_veri_parms.dart
// Description: This file contains models for the otp verification related requests.

class OtpVerificationParams {
  final String transactionId;
  final String otp;

  OtpVerificationParams({
    required this.transactionId,
    required this.otp,
  });

  Map<String, String> toJson() {
    return {
      'transactionId': transactionId,
      'code': otp,
    };
  }
}

class OtpVerificationResponse {
  final String detail;

  OtpVerificationResponse({
    required this.detail,
  });

  factory OtpVerificationResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerificationResponse(
      detail: json['detail'],
    );
  }
}
