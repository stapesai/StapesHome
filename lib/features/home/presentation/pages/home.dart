// File: lib/features/home/presentation/pages/home.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stapes_home/core/common/widgets/snackbar.dart';
import 'package:stapes_home/core/models/device_model.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/core/websocket/websocket_bloc.dart';
import 'package:stapes_home/core/websocket/websocket_event.dart';
import 'package:stapes_home/core/websocket/websocket_state.dart';
import 'package:stapes_home/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:stapes_home/features/common/presentation/widgets/hold_bottom_sheet_widget.dart';
import 'package:stapes_home/features/common/presentation/widgets/iot/light_widget.dart';
import 'package:stapes_home/features/devices/data/models/get_devices_api_param.dart';
import 'package:stapes_home/features/devices/domain/usecases/get_all_devices_usecase.dart';
import 'package:stapes_home/features/fav_devices/data/models/delete_fav_devices_api_params.dart';
import 'package:stapes_home/features/fav_devices/data/models/get_fav_devices_api_params.dart';
import 'package:stapes_home/features/fav_devices/domain/usecases/get_fav_devices.dart';
import 'package:stapes_home/features/fav_devices/domain/usecases/remove_fav_devices.dart';
import 'package:stapes_home/service_locator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  bool isFavouritesSelected = true;
  String? _userName;
  final Map<String, bool> _deviceOnlineStatus = {};
  final Map<String, bool> _nodeOnlineStatus = {};
  List<DeviceModel> _allDevices = [];
  List<String> _favoriteEntityIds = [];
  List<DeviceModel> _activeDevices = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadDevices();
    // Listen to websocket updates
    context.read<WebsocketBloc>().stream.listen(_handleDeviceStatusUpdate);
  }

  // Load user name from local storage
  Future<void> _loadUserName() async {
    final user = await serviceLocator<AuthLocalDataSource>().getUser();
    if (mounted) setState(() => _userName = user?.firstName);
  }

  // Load devices and favorites
  Future<void> _loadDevices() async {
    final devicesResult = await serviceLocator<GetAllDevicesUseCase>()(
      GetAllDevicesParams(),
      refresh: true,
    );

    devicesResult.fold(
      (failure) {
        if (mounted) {
          CustomSnackbar(context, failure.message, type: SnackbarType.error);
        }
      },
      (response) async {
        _allDevices = response.entities;
        await _loadFavorites();
      },
    );
  }

  // Load favorite devices
  Future<void> _loadFavorites() async {
    final favResult = await serviceLocator<GetFavDevicesUseCase>()(
      GetFavDeviceParams(),
      refresh: true,
    );

    favResult.fold(
      (failure) {
        if (mounted) {
          CustomSnackbar(context, failure.message, type: SnackbarType.error);
        }
      },
      (response) {
        if (mounted) {
          setState(() {
            _favoriteEntityIds = response.favouriteDevices.map((fav) => fav.entityId).toList();
          });
        }
      },
    );
  }

  // Get favorite devices by mapping IDs to full device objects
  List<DeviceModel> get _favoriteDevices {
    return _allDevices.where((device) => _favoriteEntityIds.contains(device.id)).toList();
  }

  // Handle websocket device status updates
  void _handleDeviceStatusUpdate(WebsocketState state) {
    if (state is WebsocketDeviceStatusUpdateMessageState) {
      setState(() {
        _deviceOnlineStatus[state.update.deviceId] = state.update.isOnline;
        _updateActiveDevices();
      });
    } else if (state is WebsocketNodeStatusUpdateMessageState) {
      setState(() {
        _nodeOnlineStatus[state.update.nodeId] = state.update.isOnline;
      });
    } else if (state is WebsocketConnecting) {
      setState(() {
        _deviceOnlineStatus.clear();
        _nodeOnlineStatus.clear();
      });
    }
  }

  // Update list of active devices based on online status
  void _updateActiveDevices() {
    setState(() {
      _activeDevices = _allDevices.where((device) => _deviceOnlineStatus[device.id] == true).toList();
    });
  }

  // Remove device from favorites
  Future<void> _removeFavorite(String deviceId) async {
    final result = await serviceLocator<RemoveFavDeviceUseCase>()(
      DeleteFavDeviceParams(entityId: deviceId),
    );

    result.fold(
      (failure) {
        if (mounted) {
          CustomSnackbar(context, failure.message, type: SnackbarType.error);
        }
      },
      (success) {
        if (mounted) {
          setState(() {
            _favoriteEntityIds.remove(deviceId);
          });
          CustomSnackbar(context, 'Removed from favorites');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final screenSize = MediaQuery.of(context).size;
    final devices = isFavouritesSelected ? _favoriteDevices : _activeDevices;

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenSize.height * 0.05),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good Morning,',
                      style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: 16.sp,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      _userName ?? 'User',
                      style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: 40.sp,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenSize.height * 0.03),
              Row(
                children: [
                  _buildQuickAccessButton(
                    'Favourites',
                    isFavouritesSelected,
                    'heart-active.svg',
                    'heart.svg',
                  ),
                  SizedBox(width: 24),
                  _buildQuickAccessButton(
                    'Active',
                    !isFavouritesSelected,
                    'lightning-active.svg',
                    'lightning.svg',
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: screenSize.height * 0.05),
          // Devices grid section
          Expanded(
            child: devices.isEmpty
                ? SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Center(
                      child: SizedBox(
                        child: Center(
                          child: Text(
                            isFavouritesSelected
                                ? "Nothing to show here.\nGo to Devices page and add a device to favorites list."
                                : "No devices are currently active",
                            style: TextStyle(
                              color: AppColor.whiteColor.withOpacity(0.8),
                              fontSize: 16.sp,
                              fontFamily: 'Ubuntu',
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  )
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: devices.length,
                    itemBuilder: (context, index) {
                      final device = devices[index];
                      return LightComponentWidget(
                        device: device,
                        isActivated: _deviceOnlineStatus[device.id] ?? false,
                        isEnabled: _nodeOnlineStatus[device.nodeId] ?? false,
                        isFavorite: _favoriteEntityIds.contains(device.id),
                        onToggle: _nodeOnlineStatus[device.nodeId] ?? false
                            ? () {
                                context.read<WebsocketBloc>().add(
                                      WebsocketSendDeviceControlRequest(
                                        deviceId: device.id!,
                                        state: !(_deviceOnlineStatus[device.id] ?? false),
                                      ),
                                    );
                              }
                            : null,
                        onLongPress: () {
                          if (isFavouritesSelected) {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => HoldBottomSheetWidget(
                                options: [
                                  BottomSheetOption(
                                    icon: Icons.favorite_border,
                                    label: 'Remove from Favorites',
                                    onTap: () async {
                                      await _removeFavorite(device.id!);
                                    },
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
    );
  }

  // Build quick access toggle button
  Widget _buildQuickAccessButton(String label, bool isActive, String activeIcon, String inactiveIcon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isFavouritesSelected = (label == 'Favourites');
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            isActive ? 'assets/icons/home/$activeIcon' : 'assets/icons/home/$inactiveIcon',
            width: 20.w,
          ),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isActive ? AppColor.whiteColor : AppColor.whiteColor.withOpacity(0.5),
              fontSize: 16.sp,
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
