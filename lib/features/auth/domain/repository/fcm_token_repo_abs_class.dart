// lib/features/auth/domain/repository/fcm_token_repo_abs_class.dart

import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';

abstract class FCMTokenRepository {
  Future<Either<Failure, String?>> getFCMToken();
  Stream<String> onTokenRefresh();
  Future<Either<Failure, void>> deleteToken();
  Future<Either<Failure, void>> updateFCMToken(String token);
}
