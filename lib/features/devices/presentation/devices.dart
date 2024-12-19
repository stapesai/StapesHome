import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/core/theme/app_font_sizes.dart';
import 'package:stapes_home/core/theme/app_padding.dart';
import 'package:stapes_home/features/common/presentation/widgets/iot/light_widget.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/widgets/floor_room_sel_widget.dart';
import 'package:stapes_home/core/websocket/websocket_bloc.dart';
import 'package:stapes_home/core/websocket/websocket_event.dart';
import 'package:stapes_home/core/websocket/websocket_state.dart';

class DeviceScreen extends StatelessWidget {
  const DeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return BlocProvider<WebsocketBloc>(
      create: (context) => WebsocketBloc()..add(ConnectWebsocketEvent()),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocListener<WebsocketBloc, WebsocketState>(
          listener: (context, state) {
            if (state is WebsocketErrorOccurredState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Padding(
                    padding: AppPadding.pagePadding(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'All Devices',
                          style: TextStyle(
                            fontSize: AppFontSizes.pageHeading,
                            fontWeight: FontWeight.bold,
                            color: AppColor.whiteColor,
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.04),
                        FloorRoomSelector(
                          onFloorSelected: (String floorId) {},
                          onRoomSelected: (String roomId) {},
                        ),
                        SizedBox(height: screenSize.height * 0.05),
                        BlocBuilder<WebsocketBloc, WebsocketState>(
                          builder: (context, state) {
                            if (state is WebsocketDeviceStatusUpdateMessageState) {
                              final devices = state.update.devices;
                              return Wrap(
                                spacing: 7.0,
                                children: devices.map((device) {
                                  return LightComponentWidget(
                                    device: device,
                                    onToggle: () {
                                      context.read<WebsocketBloc>().add(
                                            WebsocketSendDeviceControlRequest(
                                              deviceId: device.id,
                                              state: !device.isOn,
                                            ),
                                          );
                                    },
                                    isActivated: device.isOn,
                                  );
                                }).toList(),
                              );
                            } else if (state is WebsocketConnecting) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return Center(child: Text('No devices found'));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
