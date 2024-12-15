import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:stapes_home/core/network/network_info.dart';
import 'package:stapes_home/core/database/sqlite_service.dart';
import 'package:stapes_home/core/network/http_client.dart';
import 'package:stapes_home/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:stapes_home/features/auth/data/datasources/local/device_info_data_source.dart';
import 'package:stapes_home/features/auth/data/repositories/auth_abs_class_impl.dart';
import 'package:stapes_home/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:stapes_home/features/auth/data/repositories/device_info_abs_class_impl.dart';
import 'package:stapes_home/features/auth/domain/repository/auth_abs_class.dart';
import 'package:stapes_home/features/auth/domain/repository/device_info_abs_class.dart';
import 'package:stapes_home/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:stapes_home/features/auth/domain/usecases/get_device_info_usecase.dart';
import 'package:stapes_home/features/auth/domain/usecases/login_usecase.dart';
import 'package:stapes_home/features/auth/domain/usecases/otp_verification_usecase.dart';
import 'package:stapes_home/features/auth/domain/usecases/signup_usecase.dart';
import 'package:stapes_home/features/devices/data/datasources/local/devices_local_datasource.dart';
import 'package:stapes_home/features/devices/data/datasources/remote/devices_remote_datasource.dart';
import 'package:stapes_home/features/devices/data/repositories/devices_repository_impl.dart';
import 'package:stapes_home/features/devices/domain/repositories/devices_repository.dart';
import 'package:stapes_home/features/devices/domain/usecases/create_device_usecase.dart';
import 'package:stapes_home/features/devices/domain/usecases/delete_device_usecase.dart';
import 'package:stapes_home/features/devices/domain/usecases/get_devices_by_node_id_usecase.dart';
import 'package:stapes_home/features/devices/domain/usecases/get_devices_by_room_id_usecase.dart';
import 'package:stapes_home/features/devices/domain/usecases/update_device_usecase.dart';
import 'package:stapes_home/features/fav_devices/data/datasources/local/fav_device_local_datasource.dart';
import 'package:stapes_home/features/fav_devices/data/datasources/remote/fav_device_remote_datasource.dart';
import 'package:stapes_home/features/fav_devices/data/repositories/fav_device_repository_impl.dart';
import 'package:stapes_home/features/fav_devices/domain/repositories/fav_device_repository.dart';
import 'package:stapes_home/features/fav_devices/domain/usecases/create_fav_devices.dart';
import 'package:stapes_home/features/fav_devices/domain/usecases/get_fav_devices.dart';
import 'package:stapes_home/features/fav_devices/domain/usecases/remove_fav_devices.dart';
import 'package:stapes_home/features/floors/data/datasources/local/floors_local_datasource.dart';
import 'package:stapes_home/features/floors/data/datasources/remote/floors_remote_datasource.dart';
import 'package:stapes_home/features/floors/data/repositories/floor_repository_impl.dart';
import 'package:stapes_home/features/floors/domain/repository/floor_repository.dart';
import 'package:stapes_home/features/floors/domain/usecases/create_floor_usecase.dart';
import 'package:stapes_home/features/floors/domain/usecases/delete_floor_usecase.dart';
import 'package:stapes_home/features/floors/domain/usecases/get_floors_usecase.dart';
import 'package:stapes_home/features/floors/domain/usecases/update_floor_usecase.dart';
import 'package:stapes_home/features/iot_provisioning/data/datasources/local/ble_local_datasource.dart';
import 'package:stapes_home/features/iot_provisioning/data/datasources/local/wifi_local_datasource.dart';
import 'package:stapes_home/features/iot_provisioning/data/repository/iot_provisioning_repo_imp.dart';
import 'package:stapes_home/features/iot_provisioning/domain/repository/iot_provisioning_repo.dart';
import 'package:stapes_home/features/iot_provisioning/domain/usecase/iot_provisioning_ble_check_wifi_credentials.dart';
import 'package:stapes_home/features/iot_provisioning/domain/usecase/iot_provisioning_ble_get_hw_info.dart';
import 'package:stapes_home/features/iot_provisioning/domain/usecase/iot_provisioning_ble_pair_node.dart';
import 'package:stapes_home/features/iot_provisioning/domain/usecase/iot_provisioning_ble_upload_config.dart';
import 'package:stapes_home/features/iot_provisioning/domain/usecase/iot_provisioning_wifi_get_available_nwtworks.dart';
import 'package:stapes_home/features/nodes/data/datasources/local/nodes_local_datasource.dart';
import 'package:stapes_home/features/nodes/data/datasources/remote/nodes_remote_datasource.dart';
import 'package:stapes_home/features/nodes/data/repositories/node_repository_impl.dart';
import 'package:stapes_home/features/nodes/domain/repository/node_repository.dart';
import 'package:stapes_home/features/nodes/domain/usecases/pair_node_usecase.dart';
import 'package:stapes_home/features/nodes/domain/usecases/delete_node_usecase.dart';
import 'package:stapes_home/features/nodes/domain/usecases/get_nodes_by_room_id_usecase.dart';
import 'package:stapes_home/features/nodes/domain/usecases/update_node_usecase.dart';
import 'package:stapes_home/features/rooms/data/datasources/local/rooms_local_datasource.dart';
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
  /**
   * Analysis of registerSingleton vs registerLazySingleton
      Key Differences:
        registerSingleton: Creates instance immediately at registration
        registerLazySingleton: Creates instance only when first requested
      Benefits of registerLazySingleton:
        Improved app startup time
        Lower initial memory usage
        Better for dependencies not needed immediately
      Drawbacks of registerLazySingleton:
        Slight delay on first access
        Not ideal for services needed immediately at startup
        Could cause timing issues if initialization order matters
      Recommendation:
        Keep registerSingleton for Core services needed at startup:
          NetworkInfo
          HttpClient
          SQLiteService
          HiveInterface

        Convert to registerLazySingleton for Feature-specific services:
          Use cases
          Repositories
          Data sources
   */
  // Optimize the registration of services and use cases.
  // ---------------------Common services---------------------
  serviceLocator.registerSingleton<HttpClient>(HttpClient());
  serviceLocator.registerSingleton<NetworkInfo>(NetworkInfoImpl(InternetConnectionChecker()));
  // serviceLocator.registerSingleton<WebsocketService>(WebsocketService());
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

  // ---------------------DeviceInfo feature---------------------
  // Data sources
  serviceLocator.registerSingleton<DeviceInfoPlugin>(
    DeviceInfoPlugin(),
  );
  serviceLocator.registerSingleton<DeviceInfoDataSource>(
    DeviceInfoDataSourceImpl(deviceInfo: serviceLocator<DeviceInfoPlugin>()),
  );

  // Repositories
  serviceLocator.registerSingleton<DeviceInfoRepository>(
    DeviceInfoRepositoryImpl(dataSource: serviceLocator<DeviceInfoDataSource>()),
  );

  // Use cases
  serviceLocator.registerSingleton<GetDeviceInfoUseCase>(
    GetDeviceInfoUseCase(serviceLocator<DeviceInfoRepository>()),
  );

  // ---------------------Floors feature---------------------
  // Data sources
  serviceLocator.registerSingleton<FloorsRemoteDataSource>(FloorsRemoteDataSourceImpl(
    httpClient: serviceLocator<HttpClient>(),
    authLocalDataSource: serviceLocator<AuthLocalDataSource>(),
  ));
  serviceLocator.registerSingleton<FloorsLocalDataSource>(FloorsLocalDataSourceImpl(
    sqliteService: serviceLocator<SQLiteService>(),
  ));

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
    authLocalDataSource: serviceLocator<AuthLocalDataSource>(),
  ));
  serviceLocator.registerSingleton<RoomsLocalDataSource>(RoomsLocalDataSourceImpl(
    sqliteService: serviceLocator<SQLiteService>(),
  ));

  // Repositories
  serviceLocator.registerSingleton<RoomRepository>(RoomRepositoryImpl(
    remoteDataSource: serviceLocator<RoomsRemoteDataSource>(),
    localDataSource: serviceLocator<RoomsLocalDataSource>(),
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
    authLocalDataSource: serviceLocator<AuthLocalDataSource>(),
  ));
  serviceLocator.registerSingleton<NodesLocalDataSource>(NodesLocalDataSourceImpl(
    sqliteService: serviceLocator<SQLiteService>(),
  ));

  // Repositories
  serviceLocator.registerSingleton<NodeRepository>(NodeRepositoryImpl(
    remoteDataSource: serviceLocator<NodesRemoteDataSource>(),
    localDataSource: serviceLocator<NodesLocalDataSource>(),
    networkInfo: serviceLocator<NetworkInfo>(),
  ));

  // Use cases
  serviceLocator.registerSingleton<GetNodesByRoomIdUseCase>(GetNodesByRoomIdUseCase());
  serviceLocator.registerSingleton<RequestNodePairingUseCase>(RequestNodePairingUseCase());
  serviceLocator.registerSingleton<CompleteNodePairingUseCase>(CompleteNodePairingUseCase());
  serviceLocator.registerSingleton<DeleteNodeUseCase>(DeleteNodeUseCase());
  serviceLocator.registerSingleton<UpdateNodeUseCase>(UpdateNodeUseCase());

  // ---------------------IoT Provisioning feature---------------------
  // Data sources
  serviceLocator.registerSingleton<BleLocalDataSource>(
    BleLocalDataSourceImpl(),
  );
  serviceLocator.registerSingleton<WifiLocalDataSource>(
    WifiLocalDataSourceImpl(),
  );

  // Repository
  serviceLocator.registerSingleton<IotProvisioningRepository>(
    IotProvisioningRepositoryImpl(
      bleDataSource: serviceLocator<BleLocalDataSource>(),
      wifiDataSource: serviceLocator<WifiLocalDataSource>(),
    ),
  );

  // Use cases
  serviceLocator.registerSingleton<PairBleNodeUseCase>(
    PairBleNodeUseCase(iotProvisioningRepository: serviceLocator<IotProvisioningRepository>()),
  );

  serviceLocator.registerSingleton<GetAvailableWifiNetworksUseCase>(
    GetAvailableWifiNetworksUseCase(serviceLocator<IotProvisioningRepository>()),
  );

  serviceLocator.registerSingleton<CheckWifiCredentialsUseCase>(
    CheckWifiCredentialsUseCase(serviceLocator<IotProvisioningRepository>()),
  );

  serviceLocator.registerSingleton<GetHwInfoUseCase>(
    GetHwInfoUseCase(serviceLocator<IotProvisioningRepository>()),
  );

  serviceLocator.registerSingleton<SendConfigToNodeUseCase>(
    SendConfigToNodeUseCase(serviceLocator<IotProvisioningRepository>()),
  );

  // ---------------------Devices feature---------------------
  // Data sources
  serviceLocator.registerSingleton<DevicesRemoteDataSource>(DevicesRemoteDataSourceImpl(
    httpClient: serviceLocator<HttpClient>(),
    authLocalDataSource: serviceLocator<AuthLocalDataSource>(),
  ));
  serviceLocator.registerSingleton<DevicesLocalDataSource>(DevicesLocalDataSourceImpl(
    sqliteService: serviceLocator<SQLiteService>(),
  ));

  // Repositories
  serviceLocator.registerSingleton<DevicesRepository>(DevicesRepositoryImpl(
    remoteDataSource: serviceLocator<DevicesRemoteDataSource>(),
    localDataSource: serviceLocator<DevicesLocalDataSource>(),
    networkInfo: serviceLocator<NetworkInfo>(),
  ));

  // Use cases
  serviceLocator.registerSingleton<GetDevicesByRoomIdUseCase>(GetDevicesByRoomIdUseCase());
  serviceLocator.registerSingleton<GetDevicesByNodeIdUseCase>(GetDevicesByNodeIdUseCase());
  serviceLocator.registerSingleton<CreateDeviceUseCase>(CreateDeviceUseCase());
  serviceLocator.registerSingleton<DeleteDeviceUseCase>(DeleteDeviceUseCase());
  serviceLocator.registerSingleton<UpdateDeviceUseCase>(UpdateDeviceUseCase());

  // ---------------------Favorites Devices feature---------------------
  // Data sources
  serviceLocator.registerSingleton<FavDevicesRemoteDataSource>(FavDevicesRemoteDataSourceImpl(
    httpClient: serviceLocator<HttpClient>(),
    authLocalDataSource: serviceLocator<AuthLocalDataSource>(),
  ));
  serviceLocator.registerSingleton<FavDevicesLocalDataSource>(FavDevicesLocalDataSourceImpl(
    sqliteService: serviceLocator<SQLiteService>(),
  ));

  // Repositories
  serviceLocator.registerSingleton<FavDeviceRepository>(FavDeviceRepositoryImpl(
    remoteDataSource: serviceLocator<FavDevicesRemoteDataSource>(),
    localDataSource: serviceLocator<FavDevicesLocalDataSource>(),
    networkInfo: serviceLocator<NetworkInfo>(),
  ));

  // Use cases
  serviceLocator.registerSingleton<GetFavDevicesUseCase>(GetFavDevicesUseCase());
  serviceLocator.registerSingleton<CreateFavDeviceUseCase>(CreateFavDeviceUseCase());
  serviceLocator.registerSingleton<RemoveFavDeviceUseCase>(RemoveFavDeviceUseCase());
}
