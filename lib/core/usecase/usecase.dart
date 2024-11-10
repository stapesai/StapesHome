// Path: lib/core/usecase/usecase.dart
// Description: This file contains the abstract class for the use case.
// We'll extend this class to create use cases for different features in the application.

abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}
