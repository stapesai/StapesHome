// lib/features/auth/domain/usecases/fcm_token_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/models/no_params.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/auth/domain/repository/fcm_token_repo_abs_class.dart';

class GetFCMTokenUseCase implements UseCase<NoParams, String?> {
  final FCMTokenRepository repository;

  GetFCMTokenUseCase(this.repository);

  @override
  Future<Either<Failure, String?>> call(NoParams params) {
    return repository.getFCMToken();
  }
}

class UpdateFCMTokenUseCase implements UseCase<String, void> {
  final FCMTokenRepository repository;

  UpdateFCMTokenUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String token) {
    return repository.updateFCMToken(token);
  }
}

class DeleteFCMTokenUseCase implements UseCase<NoParams, void> {
  final FCMTokenRepository repository;

  DeleteFCMTokenUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.deleteToken();
  }
}
