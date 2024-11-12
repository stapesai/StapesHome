// Path: lib/service_locator.dart
// Description: This file contains the service locators for the application.

import 'package:get_it/get_it.dart';
import 'package:stapes_home/core/network/http_client.dart';
import 'package:stapes_home/features/auth/data/repositories/auth_abs_class_impl.dart';
import 'package:stapes_home/features/auth/data/datasources/remote/auth_api_datasource.dart';
import 'package:stapes_home/features/auth/domain/repository/auth_abs_class.dart';
import 'package:stapes_home/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:stapes_home/features/auth/domain/usecases/login_usecase.dart';
import 'package:stapes_home/features/auth/domain/usecases/otp_verification_usecase.dart';
import 'package:stapes_home/services/websocket_service.dart';
import 'package:stapes_home/utils/hive.dart';

final GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  // This will help us to use the same instance of HttpClient throughout the app.
  serviceLocator.registerSingleton<HttpClient>(HttpClient());
  // serviceLocator.registerSingleton<WebSocketService>(WebSocketService());

  // TODO: make interface for hive service
  serviceLocator.registerSingleton<HiveService>(HiveService());

  // Register services (API or local services) with their implementations
  serviceLocator.registerSingleton<AuthApiService>(AuthApiServiceImpl());

  // Register repositories with their implementations
  serviceLocator.registerSingleton<AuthRepository>(AuthRepositoryImpl());

  // Register use cases with their implementations
  serviceLocator.registerSingleton<RequestLoginUseCase>(RequestLoginUseCase());
  serviceLocator.registerSingleton<CompleteLoginUseCase>(CompleteLoginUseCase());
  serviceLocator.registerSingleton<OtpVerificationUsecase>(OtpVerificationUsecase());
  serviceLocator.registerSingleton<RequestPasswordResetUseCase>(RequestPasswordResetUseCase());
  serviceLocator.registerSingleton<CompletePasswordResetUseCase>(CompletePasswordResetUseCase());
}
