// File: lib/domain/entities/otp_info.dart
// Description: This file contains the OtpInfo entity class which represents OTP-related information.

import 'package:equatable/equatable.dart';

class OtpInfo extends Equatable {
  final String transactionId;
  final DateTime expiryTime;

  const OtpInfo({
    required this.transactionId,
    required this.expiryTime,
  });

  @override
  List<Object> get props => [transactionId, expiryTime];
}
