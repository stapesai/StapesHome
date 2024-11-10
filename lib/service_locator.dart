// Path: lib/service_locator.dart
// Description: This file contains the service locators for the application.

import 'package:get_it/get_it.dart';
import 'package:stapes_home/core/network/http_client.dart';
import 'package:stapes_home/core/usecase/usecase.dart';
import 'package:stapes_home/data/repository/auth_abs_impl.dart';
import 'package:stapes_home/data/source/auth_api_service.dart';
import 'package:stapes_home/domain/repository/auth_abs_class.dart';
import 'package:stapes_home/domain/usecases/login.dart';

final GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  // This will help us to use the same instance of HttpClient throughout the app.
  serviceLocator.registerSingleton<HttpClient>(HttpClient());

  // Register services (API or local services) with their implementations
  serviceLocator.registerSingleton<AuthApiService>(AuthApiServiceImpl());

  // Register repositories with their implementations
  serviceLocator.registerSingleton<AuthRepository>(AuthRepositoryImpl());

  // Register use cases with their implementations
  serviceLocator.registerSingleton<UseCase>(RequestLoginUseCase());
}
