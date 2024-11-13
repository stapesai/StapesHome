import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/exceptions.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:stapes_home/features/auth/data/models/forgot_password_api_parms.dart';
import 'package:stapes_home/features/auth/data/models/login_api_parms.dart';
import 'package:stapes_home/features/auth/data/models/otp_verification_api_parms.dart';
import 'package:stapes_home/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:stapes_home/features/auth/data/models/signup_api_parms.dart';
import 'package:stapes_home/features/auth/domain/repository/auth_abs_class.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  // Login
  @override
  Future<Either<Failure, RequestLoginResponse>> requestLogin(RequestLoginParams requestLoginParams) async {
    try {
      final response = await remoteDataSource.requestLoginService(requestLoginParams);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return Left(NetworkFailure(message: 'Unable to connect to internet'));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CompleteLoginResponse>> completeLogin(CompleteLoginParams completeLoginParams) async {
    try {
      final response = await remoteDataSource.completeLogin(completeLoginParams);
      await localDataSource.cacheUserSession(response.session);
      await localDataSource.cacheUser(response.user);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return Left(NetworkFailure(message: 'Unable to connect to internet'));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  // SignUp
  @override
  Future<Either<Failure, RequestSignUpResponse>> requestSignUp(RequestSignUpParams requestSignupParams) async {
    try {
      final response = await remoteDataSource.requestSignUp(requestSignupParams);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return Left(NetworkFailure(message: 'Unable to connect to internet'));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CompleteSignUpResponse>> completeSignUp(CompleteSignUpParams completeSignupParams) async {
    try {
      final response = await remoteDataSource.completeSignUp(completeSignupParams);
      await localDataSource.cacheUserSession(response.session);
      await localDataSource.cacheUser(response.user);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return Left(NetworkFailure(message: 'Unable to connect to internet'));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  // Forgot Password
  @override
  Future<Either<Failure, RequestPasswordResetResponse>> requestPasswordReset(
      RequestPasswordResetParams requestPasswordResetParams) async {
    try {
      final response = await remoteDataSource.requestPasswordReset(requestPasswordResetParams);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return Left(NetworkFailure(message: 'Unable to connect to internet'));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CompletePasswordResetResponse>> completePasswordReset(
      CompletePasswordResetParams completePasswordResetParams) async {
    try {
      final response = await remoteDataSource.completePasswordReset(completePasswordResetParams);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return Left(NetworkFailure(message: 'Unable to connect to internet'));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  // OTP Verification
  @override
  Future<Either<Failure, OtpVerificationResponse>> verifyOtp(OtpVerificationParams otpVerificationParams) async {
    try {
      final response = await remoteDataSource.verifyOtp(otpVerificationParams);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return Left(NetworkFailure(message: 'Unable to connect to internet'));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
