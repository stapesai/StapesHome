// File: lib/data/repositories/user_repository_impl.dart
// Description: This file contains the implementation of the UserRepository interface.

import 'package:dartz/dartz.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../../core/network/network_info.dart';
import '../datasources/user_remote_data_source.dart';
import '../datasources/user_local_data_source.dart';
import '../models/user_model.dart';

/// Implements the UserRepository interface
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  /// Creates a new UserRepositoryImpl instance
  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.getCurrentUser();
        localDataSource.cacheUser(remoteUser);
        return Right(remoteUser);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localUser = await localDataSource.getLastUser();
        return Right(localUser);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, bool>> updateUserProfile(User user) async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = UserModel(
          id: user.id,
          email: user.email,
          firstName: user.firstName,
          lastName: user.lastName,
          dateOfBirth: user.dateOfBirth,
          gender: user.gender,
        );
        final result = await remoteDataSource.updateUserProfile(userModel);
        if (result) {
          localDataSource.cacheUser(userModel);
        }
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> changePassword(String currentPassword, String newPassword) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.changePassword(currentPassword, newPassword);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      } on UnauthorizedException {
        return Left(AuthenticationFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.logout();
        if (result) {
          await localDataSource.clearUser();
        }
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      // Even if offline, we can clear local data
      await localDataSource.clearUser();
      return const Right(true);
    }
  }
}
