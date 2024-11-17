import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:stapes_home/core/database/sqlite_service.dart';
import 'package:stapes_home/core/network/http_client.dart';
import 'package:stapes_home/core/websocket/websocket_service.dart';
import 'package:stapes_home/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:stapes_home/features/auth/data/repositories/auth_abs_class_impl.dart';
import 'package:stapes_home/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:stapes_home/features/auth/domain/repository/auth_abs_class.dart';
import 'package:stapes_home/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:stapes_home/features/auth/domain/usecases/login_usecase.dart';
import 'package:stapes_home/features/auth/domain/usecases/otp_verification_usecase.dart';
import 'package:stapes_home/features/auth/domain/usecases/signup_usecase.dart';
import 'package:stapes_home/features/nodes/data/datasources/local/nodes_local_datasource.dart';
import 'package:stapes_home/features/nodes/data/datasources/remote/nodes_remote_datasource.dart';
import 'package:stapes_home/features/nodes/data/repositories/node_repository_impl.dart';
import 'package:stapes_home/features/nodes/domain/repository/node_repository.dart';

final GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  // TODO: difference between registerSingleton and registerLazySingleton.
  // Optimize the registration of services and use cases.
  // ---------------------Common services---------------------
  serviceLocator.registerSingleton<HttpClient>(HttpClient());
  serviceLocator.registerLazySingleton<WebsocketService>(() => WebsocketService());
  serviceLocator.registerSingleton<HiveInterface>(Hive);
  serviceLocator.registerLazySingleton(() => SQLiteService());

  // ---------------------Auth feature---------------------
  // Data sources
  serviceLocator.registerSingleton<AuthRemoteDataSource>(AuthRemoteDataSourceImpl(
    httpClient: serviceLocator<HttpClient>(),
  ));
  serviceLocator.registerSingleton<AuthLocalDataSource>(AuthLocalDataSourceImpl(hive: serviceLocator<HiveInterface>()));

  // Repositories
  serviceLocator.registerSingleton<AuthRepository>(AuthRepositoryImpl(
    remoteDataSource: serviceLocator<AuthRemoteDataSource>(),
    localDataSource: serviceLocator<AuthLocalDataSource>(),
  ));

  // Use cases
  serviceLocator.registerSingleton<RequestLoginUseCase>(RequestLoginUseCase());
  serviceLocator.registerSingleton<CompleteLoginUseCase>(CompleteLoginUseCase());
  serviceLocator.registerSingleton<OtpVerificationUsecase>(OtpVerificationUsecase());
  serviceLocator.registerSingleton<RequestPasswordResetUseCase>(RequestPasswordResetUseCase());
  serviceLocator.registerSingleton<CompletePasswordResetUseCase>(CompletePasswordResetUseCase());
  serviceLocator.registerSingleton<RequestSignUpUseCase>(RequestSignUpUseCase());
  serviceLocator.registerSingleton<CompleteSignUpUseCase>(CompleteSignUpUseCase());

  // ---------------------Nodes feature---------------------
  // Data sources
  serviceLocator.registerSingleton<NodesRemoteDataSource>(NodesRemoteDataSourceImpl(
    httpClient: serviceLocator<HttpClient>(),
  ));
  serviceLocator.registerSingleton<NodesLocalDataSource>(NodesLocalDataSourceImpl(
    sqliteService: serviceLocator<SQLiteService>(),
  ));

  // Repositories
  serviceLocator.registerSingleton<NodeRepository>(NodeRepositoryImpl(
    remoteDataSource: serviceLocator<NodesRemoteDataSource>(),
    localDataSource: serviceLocator<NodesLocalDataSource>(),
  ));

  // Use cases
  // serviceLocator.registerSingleton<GetNodesByRoomIdUseCase>(GetNodesByRoomIdUseCase());
  // serviceLocator.registerSingleton<GetCachedNodesUseCase>(GetCachedNodesUseCase());
  // serviceLocator.registerSingleton<CreateNodeUseCase>(CreateNodeUseCase());
  // serviceLocator.registerSingleton<DeleteNodeUseCase>(DeleteNodeUseCase());
  // serviceLocator.registerSingleton<UpdateNodeUseCase>(UpdateNodeUseCase());
}
