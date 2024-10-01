// File: lib/core/usecases/usecase.dart
// Description: This file contains the definition of the UseCase abstract class, which serves as a base for all use cases in the application.

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failures.dart';

/// Abstract class representing a use case in the application
///
/// Type parameters:
/// - Type: The return type of the use case
/// - Params: The type of parameters the use case accepts
abstract class UseCase<Type, Params> {
  /// Executes the use case
  ///
  /// Parameters:
  /// - params: The parameters required by the use case
  ///
  /// Returns:
  /// A [Future] that resolves to an [Either] containing a [Failure] or the result of type [Type]
  Future<Either<Failure, Type>> call(Params params);
}

/// Represents a use case that doesn't require any parameters
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
