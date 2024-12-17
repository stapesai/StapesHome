// lib/features/auth/data/models/fcm_token_api_params.dart

import 'dart:convert';

class UpdateFCMTokenParams {
  final String fcmToken;

  UpdateFCMTokenParams({
    required this.fcmToken,
  });

  Object toJson() {
    return jsonEncode({
      'fcm_token': fcmToken,
    });
  }
}

class UpdateFCMTokenResponse {
  final bool success;

  UpdateFCMTokenResponse({
    required this.success,
  });

  factory UpdateFCMTokenResponse.fromJson(Map<String, dynamic> response) {
    return UpdateFCMTokenResponse(
      success: response['success'],
    );
  }
}
