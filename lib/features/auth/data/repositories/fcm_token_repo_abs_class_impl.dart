// lib/features/auth/data/repositories/fcm_token_repo_abs_class_impl.dart

import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/exceptions.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/network/network_info.dart';
import 'package:stapes_home/core/utils/repository_exceptions_helper.dart';
import 'package:stapes_home/features/auth/data/datasources/local/fcm_token_local_datasource.dart';
import 'package:stapes_home/features/auth/data/datasources/remote/fcm_token_remote_datasource.dart';
import 'package:stapes_home/features/auth/data/models/fcm_token_api_params.dart';
import 'package:stapes_home/features/auth/domain/repository/fcm_token_repo_abs_class.dart';

class FCMTokenRepositoryImpl with RepositoryHelper implements FCMTokenRepository {
  final FCMTokenLocalDatasource localDatasource;
  final FCMTokenRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  FCMTokenRepositoryImpl({
    required this.localDatasource,
    required this.networkInfo,
    required this.remoteDatasource,
  });

  @override
  Future<Either<Failure, String?>> getFCMToken() async {
    try {
      final token = await localDatasource.getFCMToken();
      return Right(token);
    } on FCMTokenException catch (e) {
      return Left(FCMTokenFailure(message: e.message));
    }
  }

  @override
  Stream<String> onTokenRefresh() {
    return localDatasource.onTokenRefresh();
  }

  @override
  Future<Either<Failure, void>> deleteToken() async {
    try {
      await localDatasource.deleteToken();
      return const Right(null);
    } on FCMTokenException catch (e) {
      return Left(FCMTokenFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UpdateFCMTokenResponse>> updateFCMToken(UpdateFCMTokenParams params) {
    return handleEither(() async {
      final response = await remoteDatasource.updateFCMToken(params);
      return response;
    }, networkInfo);
  }
}
