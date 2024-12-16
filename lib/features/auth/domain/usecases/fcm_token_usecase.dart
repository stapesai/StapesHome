// lib/features/auth/domain/usecases/fcm_token_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/models/no_params.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/features/auth/data/models/fcm_token_api_params.dart';
import 'package:stapes_home/features/auth/domain/repository/fcm_token_repo_abs_class.dart';
import 'package:stapes_home/service_locator.dart';

class UpdateFCMTokenUseCase implements UseCase<NoParams, void> {
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    final tokenResult = await serviceLocator<FCMTokenRepository>().getFCMToken();
    return tokenResult.fold(
      (failure) => Left(failure),
      (token) => serviceLocator<FCMTokenRepository>().updateFCMToken(UpdateFCMTokenParams(fcmToken: token!)),
    );
  }
}

class DeleteFCMTokenUseCase implements UseCase<NoParams, void> {
  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return serviceLocator<FCMTokenRepository>().deleteToken();
  }
}
