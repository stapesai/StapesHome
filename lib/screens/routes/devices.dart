import 'dart:convert';
import 'package:StapesHome/screens/views/devices/add_new_device.dart';
import 'package:StapesHome/widgets/iot/fan.dart';
import 'package:StapesHome/widgets/iot/light.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:StapesHome/constants/api_routes.dart';
import 'package:StapesHome/constants/models.dart';
import 'package:StapesHome/constants/colors.dart';
import 'package:StapesHome/constants/font_sizes.dart';
import 'package:StapesHome/constants/padding.dart';
import 'package:StapesHome/screens/views/common/floor_room_selector.dart';

class DevicesScreen extends StatefulWidget {
  final String sessionId;
  final String userId;

  const DevicesScreen({
    Key? key,
    required this.sessionId,
    required this.userId,
  }) : super(key: key);

  @override
  createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> with AutomaticKeepAliveClientMixin {
  String activeFloorId = '';
  String activeRoomId = '';
  List<Device> devices = [];
  bool isLoading = true;
  String? errorMessage;
  final GlobalKey<FloorRoomSelectorState> _floorRoomSelectorKey = GlobalKey();

  @override
  bool get wantKeepAlive => true;

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
      _fetchDevices(roomId);
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
        devices = devicesData
            .map((device) => Device(
                  id: device['id'],
                  name: device['name'],
                  type: device['type'],
                  nodeId: device['node_id'],
                  channelId: device['channel_id'],
                ))
            .toList();
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
    await _floorRoomSelectorKey.currentState?.refreshData();
    if (activeRoomId.isNotEmpty) {
      await _fetchDevices(activeRoomId);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  padding: AppPadding.pagePadding(context),
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
                        Center(child: CircularProgressIndicator())
                      else if (errorMessage != null)
                        Text(errorMessage!, style: TextStyle(color: Colors.red))
                      else
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: devices.map<Widget>((device) {
                            if (device.type == 'light') {
                              return LightComponent(device: device);
                            } else if (device.type == 'fan') {
                              return FanComponent(device: device);
                            }
                            return Container();
                          }).toList(),
                        ),
                      SizedBox(height: screenSize.height * 0.02),
                      AddDeviceButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddDeviceButton extends StatelessWidget {
  const AddDeviceButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 90,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewDevice()));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(1, 29, 29, 29),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.98, color: Color(0xFFFF9F1C)),
            borderRadius: BorderRadius.circular(29.45),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/devices/plus.svg', width: 30, height: 30),
            SizedBox(width: 8),
            Text(
              'Add a new device',
              style: TextStyle(
                color: Colors.white.withOpacity(0.75),
                fontSize: 15.71,
                fontFamily: 'Ubuntu',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
