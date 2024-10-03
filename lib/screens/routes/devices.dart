import 'dart:convert';
import 'package:StapesHome/services/websocket_service.dart';
import 'package:StapesHome/widgets/skeletons/device.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:StapesHome/constants/colors.dart';
import 'package:StapesHome/widgets/iot/light.dart';
import 'package:StapesHome/widgets/scan_node_add_device_btn.dart';
import 'package:StapesHome/constants/api_routes.dart';
import 'package:StapesHome/constants/models.dart';
import 'package:StapesHome/constants/font_sizes.dart';
import 'package:StapesHome/constants/padding.dart';
import 'package:StapesHome/widgets/floor_room_sel.dart';
import 'package:StapesHome/screens/views/devices/add_new_device.dart';
import 'package:provider/provider.dart';

class DevicesScreen extends StatefulWidget {
  final String sessionId;
  final String userId;

  const DevicesScreen({
    super.key,
    required this.sessionId,
    required this.userId,
  });

  @override
  createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  String activeFloorId = '';
  String activeRoomId = '';
  List<Device> devices = [];
  bool isLoading = true;
  String? errorMessage;
  final GlobalKey<FloorRoomSelectorState> _floorRoomSelectorKey = GlobalKey();
  late WebSocketService _webSocketService;

  @override
  void initState() {
    super.initState();
    _webSocketService = Provider.of<WebSocketService>(context, listen: false);
    _setupWebSocketListener();
  }

  void _setupWebSocketListener() {
    _webSocketService.messageStream.listen((message) {
      if (message['type'] == 'entity_status_update') {
        _updateDeviceState(DeviceStatusUpdate.fromJson(message['data']));
      }
    });
  }

  void _updateDeviceState(DeviceStatusUpdate update) {
    setState(() {
      final deviceIndex = devices.indexWhere((d) => d.id == update.deviceId);
      if (deviceIndex != -1) {
        print('Device with name ${devices[deviceIndex].name} updated to ${update.state}');
        devices[deviceIndex] = devices[deviceIndex].copyWith(state: update.state);
      }
    });
  }

  void handleFloorSelected(String floorId) {
    if (mounted) {
      setState(() {
        activeFloorId = floorId;
      });
    }
  }

  void handleRoomSelected(String roomId) {
    if (mounted) {
      setState(() {
        activeRoomId = roomId;
      });
      if (activeRoomId.isNotEmpty) {
        _fetchDevices(roomId);
      } else {
        setState(() {
          devices = [];
        });
      }
    }
  }

  Future<void> _fetchDevices(String roomId) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(
        BackendRoutes.getEntitiesByRoomId(roomId),
        headers: {
          'accept': 'application/json',
          'X-User-Id': widget.userId,
          'X-Session-Id': widget.sessionId,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> devicesData = json.decode(response.body);
        devices = devicesData.map((device) => Device.fromJson(device)).toList();
      } else {
        throw Exception('Failed to load devices: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching devices: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    // Refresh floors and rooms while maintaining the previous selection
    await _floorRoomSelectorKey.currentState?.refreshData();
    if (activeRoomId.isNotEmpty) {
      await _fetchDevices(activeRoomId);
    }
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          gradient: AppColor.backgroundColorgradient,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: RefreshIndicator(
            onRefresh: _refreshData,
            color: AppColor.whiteColor,
            backgroundColor: Colors.transparent,
            child: SafeArea(
              child: Padding(
                padding: AppPadding.pagePadding(context),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: screenSize.height * 0.05),
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                'All Devices',
                                style: TextStyle(
                                  color: AppColor.whiteColor,
                                  fontSize: AppFontSizes.pageHeading,
                                  fontFamily: 'Ubuntu',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(height: screenSize.height * 0.02),
                            FloorRoomSelector(
                              key: _floorRoomSelectorKey,
                              context: context,
                              onFloorSelected: handleFloorSelected,
                              onRoomSelected: handleRoomSelected,
                              sessionId: widget.sessionId,
                              userId: widget.userId,
                            ),
                            SizedBox(height: screenSize.height * 0.02),
                            if (isLoading)
                              (Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: List.generate(
                                  4,
                                  (index) => Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: DevicesSkeleton(),
                                  ),
                                ),
                              ))
                            else if (errorMessage != null)
                              Text(errorMessage!, style: TextStyle(color: Colors.red))
                            else
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: devices.map<Widget>((device) {
                                  if (device.type == 'light') {
                                    return LightComponent(
                                        device: device,
                                        onToggle: (bool state) {
                                          _webSocketService.deviceStateUpdate(device.id, state);
                                        });
                                  } else if (device.type == 'fan') {
                                    // return FanComponent(device: device);
                                    throw UnimplementedError('Fan component not implemented');
                                  }
                                  return Container();
                                }).toList(),
                              ),
                            SizedBox(height: screenSize.height * 0.1),
                          ],
                        ),
                      ),
                    ),
                    ScanNodeorAddDeviceButton(
                      text: 'Add a new device',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddNewDevicePage(
                                      sessionId: widget.sessionId,
                                      userId: widget.userId,
                                    ))).then((_) => _refreshData());
                      },
                      icon: 'assets/icons/devices/plus.svg',
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
