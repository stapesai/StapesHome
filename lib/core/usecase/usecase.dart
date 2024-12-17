// Path: lib/core/usecase/usecase.dart
// Description: This file contains the abstract class for the use case.
// We'll extend this class to create use cases for different features in the application.

import 'package:dartz/dartz.dart';
import 'package:stapes_home/core/error/failures.dart';

abstract class UseCase<Params, ReturnType> {
  // Future<Type> call(Params params);
  Future<Either<Failure, ReturnType>> call(Params params);
}
