// File: lib/domain/repositories/auth_repository.dart
// Description: This file contains the AuthRepository interface which defines the contract for authentication operations.

import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/user.dart';
import '../entities/otp_info.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, OtpInfo>> signup(String email, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> verifyOtp(String transactionId, String otp);
  Future<Either<Failure, OtpInfo>> requestPasswordReset(String email);
  Future<Either<Failure, void>> resetPassword(String transactionId, String newPassword);
}
