// Path: lib/features/devices/presentation/pages/devices.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/common/widgets/snackbar.dart';
import 'package:stapes_home/core/models/device_model.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/core/theme/app_font_sizes.dart';
import 'package:stapes_home/core/websocket/websocket_bloc.dart';
import 'package:stapes_home/core/websocket/websocket_event.dart';
import 'package:stapes_home/features/common/presentation/widgets/hold_bottom_sheet_widget.dart';
import 'package:stapes_home/features/common/presentation/widgets/iot/light_widget.dart';
import 'package:stapes_home/features/common/presentation/widgets/skeletons/iot_device_skel.dart';
import 'package:stapes_home/features/devices/data/models/get_devices_api_param.dart';
import 'package:stapes_home/features/fav_devices/data/models/create_fav_devices_api_params.dart';
import 'package:stapes_home/features/fav_devices/data/models/get_fav_devices_api_params.dart';
import 'package:stapes_home/features/fav_devices/domain/usecases/create_fav_devices.dart';
import 'package:stapes_home/features/fav_devices/domain/usecases/get_fav_devices.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/widgets/floor_room_sel_widget.dart';
import 'package:stapes_home/features/devices/domain/usecases/get_devices_by_room_id_usecase.dart';
import 'package:stapes_home/core/websocket/websocket_state.dart';
import 'package:stapes_home/service_locator.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  List<String> _favoriteEntityIds = [];
  final Map<String, bool> _deviceOnlineStatus = {};
  final Map<String, bool> _nodeOnlineStatus = {};
  List<DeviceModel> _devices = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAllFavorites();
    // Listen to websocket updates
    context.read<WebsocketBloc>().stream.listen((state) {
      _handleDeviceStatusUpdate(state);
    });
  }

  void _handleDeviceStatusUpdate(WebsocketState state) {
    print('Device status update: $state');
    if (state is WebsocketDeviceStatusUpdateMessageState) {
      final deviceId = state.update.deviceId;
      setState(() {
        _deviceOnlineStatus[deviceId] = state.update.isOnline;
      });
    } else if (state is WebsocketNodeStatusUpdateMessageState) {
      final nodeId = state.update.nodeId;
      setState(() {
        _nodeOnlineStatus[nodeId] = state.update.isOnline;
      });
    } else if (state is WebsocketConnecting) {
      // Reset online status when websocket reconnects
      setState(() {
        _deviceOnlineStatus.clear();
      });
    }
  }

  Future<void> _fetchDevices(String roomId) async {
    if (roomId.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final result = await serviceLocator<GetDevicesByRoomIdUseCase>()(
      GetDevicesByRoomIdParams(roomId: roomId),
      refresh: true,
    );

    result.fold(
      (failure) {
        setState(() => _isLoading = false);
        if (context.mounted) {
          CustomSnackbar(context, failure.message, type: SnackbarType.error);
        }
      },
      (response) {
        setState(() {
          _devices = response.entities;
          // Initialize online status for all devices
          for (var device in _devices) {
            if (device.id != null) {
              _deviceOnlineStatus[device.id!] = false; // Default to offline
            }
          }
          _isLoading = false;
        });
      },
    );
  }

  Future<void> _loadAllFavorites() async {
    final result = await serviceLocator<GetFavDevicesUseCase>()(
      GetFavDeviceParams(),
      refresh: true,
    );

    result.fold(
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

  void _onFloorSelected(String floorId) {
    // Clear devices when floor changes
    setState(() {
      _devices = [];
    });
  }

  void _onRoomSelected(String roomId) {
    // Clear devices when room changes
    setState(() {
      _devices = [];
    });
    _fetchDevices(roomId);
  }

  Widget _buildDevicesList() {
    if (_isLoading) {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return const IotDevicesSkeleton();
        },
      );
    }

    if (_devices.isEmpty) {
      return const Center(
        child: Text(
          'No devices found in this room',
          style: TextStyle(
            color: AppColor.whiteColor,
            fontSize: 16,
            fontFamily: 'Ubuntu',
          ),
        ),
      );
    }

    void showDeviceOptions(BuildContext context, DeviceModel device) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => HoldBottomSheetWidget(
          options: [
            BottomSheetOption(
              icon: Icons.favorite_border,
              label: 'Add to Favorites',
              onTap: () async {
                final result = await serviceLocator<CreateFavDeviceUseCase>()(
                  CreateFavDeviceParams(entityId: device.id!),
                );

                result.fold(
                  (failure) {
                    if (context.mounted) {
                      CustomSnackbar(context, failure.message, type: SnackbarType.error);
                    }
                  },
                  (success) {
                    if (context.mounted) {
                      CustomSnackbar(context, 'Added to favorites');
                    }
                  },
                );
              },
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _devices.length,
      itemBuilder: (context, index) {
        final device = _devices[index];
        final isDeviceActive = _deviceOnlineStatus[device.id] ?? false;
        final isNodeOnline = _nodeOnlineStatus[device.nodeId] ?? false;

        if (device.type == 'light') {
          return LightComponentWidget(
            key: ValueKey(device.id),
            device: device,
            isActivated: isDeviceActive,
            isEnabled: isNodeOnline,
            isFavorite: _favoriteEntityIds.contains(device.id),
            // Only allow control if node is online
            onToggle: isNodeOnline
                ? () {
                    print('Toggling device: ${device.id}');
                    context.read<WebsocketBloc>().add(
                          WebsocketSendDeviceControlRequest(
                            deviceId: device.id!,
                            state: !isDeviceActive,
                          ),
                        );
                  }
                : null,
            onLongPress: () => showDeviceOptions(context, device),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
     return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenSize.height * 0.05),
          const Text(
            'Linked Devices',
            style: TextStyle(
              color: AppColor.whiteColor,
              fontSize: AppFontSizes.pageHeading,
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenSize.height * 0.05),
          FloorRoomSelector(
            onFloorSelected: _onFloorSelected,
            onRoomSelected: _onRoomSelected,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildDevicesList(),
            ),
          ),
        ],
    );
  }
}
