import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/utils/repository_exceptions_helper.dart';
import 'package:stapes_home/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:stapes_home/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:stapes_home/features/auth/data/models/forgot_password_api_parms.dart';
import 'package:stapes_home/features/auth/data/models/login_api_parms.dart';
import 'package:stapes_home/features/auth/data/models/otp_verification_api_parms.dart';
import 'package:stapes_home/features/auth/data/models/signup_api_parms.dart';
import 'package:stapes_home/features/auth/domain/repository/auth_abs_class.dart';

class AuthRepositoryImpl with RepositoryHelper implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, RequestLoginResponse>> requestLogin(RequestLoginParams params) {
    return handleEither(() => remoteDataSource.requestLoginService(params));
  }

  @override
  Future<Either<Failure, CompleteLoginResponse>> completeLogin(CompleteLoginParams params) {
    return handleEither(() async {
      final response = await remoteDataSource.completeLogin(params);
      await localDataSource.cacheUserSession(response.session);
      await localDataSource.cacheUser(response.user);
      return response;
    });
  }

  @override
  Future<Either<Failure, RequestSignUpResponse>> requestSignUp(RequestSignUpParams params) {
    return handleEither(() => remoteDataSource.requestSignUp(params));
  }

  @override
  Future<Either<Failure, CompleteSignUpResponse>> completeSignUp(CompleteSignUpParams params) {
    return handleEither(() async {
      final response = await remoteDataSource.completeSignUp(params);
      await localDataSource.cacheUserSession(response.session);
      await localDataSource.cacheUser(response.user);
      return response;
    });
  }

  @override
  Future<Either<Failure, RequestPasswordResetResponse>> requestPasswordReset(RequestPasswordResetParams params) {
    return handleEither(() => remoteDataSource.requestPasswordReset(params));
  }

  @override
  Future<Either<Failure, CompletePasswordResetResponse>> completePasswordReset(CompletePasswordResetParams params) {
    return handleEither(() => remoteDataSource.completePasswordReset(params));
  }

  @override
  Future<Either<Failure, OtpVerificationResponse>> verifyOtp(OtpVerificationParams params) {
    return handleEither(() => remoteDataSource.verifyOtp(params));
  }
}
