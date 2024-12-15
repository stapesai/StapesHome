import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/exceptions.dart';
import 'package:stapes_home/core/error/failures.dart';
import 'package:stapes_home/core/network/network_info.dart';

mixin RepositoryHelper {
  Future<Either<Failure, T>> handleEither<T>(
    Future<T> Function() call,
    NetworkInfo? networkInfo,
  ) async {
    try {
      if (networkInfo != null && !await networkInfo.isConnected) {
        return Left(NetworkFailure(message: 'No internet connection'));
      }
      final result = await call();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(message: e.message));
    } on TimeoutException catch (e) {
      return Left(UnexpectedFailure(message: e.message));
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(message: e.message));
    } on SQLiteException catch (e) {
      return Left(SQLiteFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
