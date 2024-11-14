import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:stapes_home/core/network/http_client.dart';
import 'package:stapes_home/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:stapes_home/features/auth/data/repositories/auth_abs_class_impl.dart';
import 'package:stapes_home/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:stapes_home/features/auth/domain/repository/auth_abs_class.dart';
import 'package:stapes_home/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:stapes_home/features/auth/domain/usecases/login_usecase.dart';
import 'package:stapes_home/features/auth/domain/usecases/otp_verification_usecase.dart';
import 'package:stapes_home/features/auth/domain/usecases/signup_usecase.dart';

final GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerSingleton<HttpClient>(HttpClient());

  // serviceLocator.registerLazySingleton<WebSocketService>(() => WebSocketService());
  serviceLocator.registerSingleton<HiveInterface>(Hive);

  // Register services (API or local services) with their implementations
  serviceLocator.registerSingleton<AuthRemoteDataSource>(AuthRemoteDataSourceImpl(
    httpClient: serviceLocator<HttpClient>(),
  ));
  serviceLocator.registerSingleton<AuthLocalDataSource>(AuthLocalDataSourceImpl(hive: serviceLocator<HiveInterface>()));

  // Register repositories with their implementations
  serviceLocator.registerSingleton<AuthRepository>(AuthRepositoryImpl(
    remoteDataSource: serviceLocator<AuthRemoteDataSource>(),
    localDataSource: serviceLocator<AuthLocalDataSource>(),
  ));

  // Register use cases with their implementations
  serviceLocator.registerSingleton<RequestLoginUseCase>(RequestLoginUseCase());
  serviceLocator.registerSingleton<CompleteLoginUseCase>(CompleteLoginUseCase());
  serviceLocator.registerSingleton<OtpVerificationUsecase>(OtpVerificationUsecase());
  serviceLocator.registerSingleton<RequestPasswordResetUseCase>(RequestPasswordResetUseCase());
  serviceLocator.registerSingleton<CompletePasswordResetUseCase>(CompletePasswordResetUseCase());
  serviceLocator.registerSingleton<RequestSignUpUseCase>(RequestSignUpUseCase());
  serviceLocator.registerSingleton<CompleteSignUpUseCase>(CompleteSignUpUseCase());
}
