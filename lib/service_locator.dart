import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:stapes_home/core/network/network_info.dart';
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
import 'package:stapes_home/features/floors/data/datasources/local/floors_local_datasource.dart';
import 'package:stapes_home/features/floors/data/datasources/remote/floors_remote_datasource.dart';
import 'package:stapes_home/features/floors/data/repositories/floor_repository_impl.dart';
import 'package:stapes_home/features/floors/domain/repository/floor_repository.dart';
import 'package:stapes_home/features/floors/domain/usecases/create_floor_usecase.dart';
import 'package:stapes_home/features/floors/domain/usecases/delete_floor_usecase.dart';
import 'package:stapes_home/features/floors/domain/usecases/get_floors_usecase.dart';
import 'package:stapes_home/features/floors/domain/usecases/update_floor_usecase.dart';
import 'package:stapes_home/features/nodes/data/datasources/remote/nodes_remote_datasource.dart';
import 'package:stapes_home/features/nodes/data/repositories/node_repository_impl.dart';
import 'package:stapes_home/features/nodes/domain/repository/node_repository.dart';
import 'package:stapes_home/features/nodes/domain/usecases/create_node_usecase.dart';
import 'package:stapes_home/features/nodes/domain/usecases/delete_node_usecase.dart';
import 'package:stapes_home/features/nodes/domain/usecases/get_nodes_by_room_id_usecase.dart';
import 'package:stapes_home/features/nodes/domain/usecases/update_node_usecase.dart';
import 'package:stapes_home/features/rooms/data/datasources/remote/rooms_remote_datasource.dart';
import 'package:stapes_home/features/rooms/data/repositories/room_repository_impl.dart';
import 'package:stapes_home/features/rooms/domain/repository/room_repository.dart';
import 'package:stapes_home/features/rooms/domain/usecases/create_room_usecase.dart';
import 'package:stapes_home/features/rooms/domain/usecases/delete_room_usecase.dart';
import 'package:stapes_home/features/rooms/domain/usecases/get_rooms_usecase.dart';
import 'package:stapes_home/features/rooms/domain/usecases/update_room_usecase.dart';

final GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  // TODO: difference between registerSingleton and registerLazySingleton.
  // Optimize the registration of services and use cases.
  // ---------------------Common services---------------------
  serviceLocator.registerSingleton<HttpClient>(HttpClient());
  serviceLocator.registerSingleton<NetworkInfo>(NetworkInfoImpl(InternetConnectionChecker()));
  serviceLocator.registerSingleton<WebsocketService>(WebsocketService());
  serviceLocator.registerSingleton<HiveInterface>(Hive);
  serviceLocator.registerSingleton<SQLiteService>(SQLiteService());

  // ---------------------Auth feature---------------------
  // Data sources
  serviceLocator.registerSingleton<AuthRemoteDataSource>(AuthRemoteDataSourceImpl(
    httpClient: serviceLocator<HttpClient>(),
  ));
  serviceLocator.registerSingleton<AuthLocalDataSource>(AuthLocalDataSourceImpl(
    // sqliteService: serviceLocator<SQLiteService>(),
    hive: serviceLocator<HiveInterface>(),
  ));

  // Repositories
  serviceLocator.registerSingleton<AuthRepository>(AuthRepositoryImpl(
    remoteDataSource: serviceLocator<AuthRemoteDataSource>(),
    localDataSource: serviceLocator<AuthLocalDataSource>(),
    networkInfo: serviceLocator<NetworkInfo>(),
  ));

  // Use cases
  serviceLocator.registerSingleton<RequestLoginUseCase>(RequestLoginUseCase());
  serviceLocator.registerSingleton<CompleteLoginUseCase>(CompleteLoginUseCase());
  serviceLocator.registerSingleton<OtpVerificationUseCase>(OtpVerificationUseCase());
  serviceLocator.registerSingleton<RequestPasswordResetUseCase>(RequestPasswordResetUseCase());
  serviceLocator.registerSingleton<CompletePasswordResetUseCase>(CompletePasswordResetUseCase());
  serviceLocator.registerSingleton<RequestSignUpUseCase>(RequestSignUpUseCase());
  serviceLocator.registerSingleton<CompleteSignUpUseCase>(CompleteSignUpUseCase());

  // ---------------------Floors feature---------------------
  // Data sources
  serviceLocator.registerSingleton<FloorsRemoteDataSource>(FloorsRemoteDataSourceImpl(
    httpClient: serviceLocator<HttpClient>(),
  ));
  // serviceLocator.registerSingleton<FloorsLocalDataSource>(FloorsLocalDataSourceImpl(
  //   sqliteService: serviceLocator<SQLiteService>(),
  // ));

  // Repositories
  serviceLocator.registerSingleton<FloorRepository>(FloorRepositoryImpl(
    remoteDataSource: serviceLocator<FloorsRemoteDataSource>(),
    localDataSource: serviceLocator<FloorsLocalDataSource>(),
    networkInfo: serviceLocator<NetworkInfo>(),
  ));

  // Use cases
  serviceLocator.registerSingleton<GetFloorsUseCase>(GetFloorsUseCase());
  serviceLocator.registerSingleton<CreateFloorUseCase>(CreateFloorUseCase());
  serviceLocator.registerSingleton<DeleteFloorUseCase>(DeleteFloorUseCase());
  serviceLocator.registerSingleton<UpdateFloorUseCase>(UpdateFloorUseCase());

  // ---------------------Rooms feature---------------------
  // Data sources
  serviceLocator.registerSingleton<RoomsRemoteDataSource>(RoomsRemoteDataSourceImpl(
    httpClient: serviceLocator<HttpClient>(),
  ));
  // serviceLocator.registerSingleton<RoomsLocalDataSource>(RoomsLocalDataSourceImpl(
  //   sqliteService: serviceLocator<SQLiteService>(),
  // ));

  // Repositories
  serviceLocator.registerSingleton<RoomRepository>(RoomRepositoryImpl(
    remoteDataSource: serviceLocator<RoomsRemoteDataSource>(),
    // localDataSource: serviceLocator<RoomsLocalDataSource>(),
    networkInfo: serviceLocator<NetworkInfo>(),
  ));

  // Use cases
  serviceLocator.registerSingleton<GetRoomsUseCase>(GetRoomsUseCase());
  serviceLocator.registerSingleton<CreateRoomUseCase>(CreateRoomUseCase());
  serviceLocator.registerSingleton<DeleteRoomUseCase>(DeleteRoomUseCase());
  serviceLocator.registerSingleton<UpdateRoomUseCase>(UpdateRoomUseCase());

  // ---------------------Nodes feature---------------------
  // Data sources
  serviceLocator.registerSingleton<NodesRemoteDataSource>(NodesRemoteDataSourceImpl(
    httpClient: serviceLocator<HttpClient>(),
  ));
  // serviceLocator.registerSingleton<NodesLocalDataSource>(NodesLocalDataSourceImpl(
  //   sqliteService: serviceLocator<SQLiteService>(),
  // ));

  // Repositories
  serviceLocator.registerSingleton<NodeRepository>(NodeRepositoryImpl(
    remoteDataSource: serviceLocator<NodesRemoteDataSource>(),
    // localDataSource: serviceLocator<NodesLocalDataSource>(),
    networkInfo: serviceLocator<NetworkInfo>(),
  ));

  // Use cases
  serviceLocator.registerSingleton<GetNodesByRoomIdUseCase>(GetNodesByRoomIdUseCase());
  serviceLocator.registerSingleton<CreateNodeUseCase>(CreateNodeUseCase());
  serviceLocator.registerSingleton<DeleteNodeUseCase>(DeleteNodeUseCase());
  serviceLocator.registerSingleton<UpdateNodeUseCase>(UpdateNodeUseCase());
}
