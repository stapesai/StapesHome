// lib/features/devices/presentation/pages/devices_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/core/theme/app_font_sizes.dart';
import 'package:stapes_home/core/theme/app_padding.dart';
import 'package:stapes_home/features/devices/presentation/bloc/devices_bloc.dart';
import 'package:stapes_home/features/devices/presentation/bloc/devices_event.dart';
import 'package:stapes_home/features/devices/presentation/bloc/devices_state.dart';
import 'package:stapes_home/features/floor_room_sel/presentation/widgets/floor_room_sel_widget.dart';
import 'package:stapes_home/features/navigation/presentation/widgets/custom_navigation_bar.dart';


class DevicesScreen extends StatefulWidget {
  const DevicesScreen({Key? key}) : super(key: key);

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  String activeFloorId = '';
  String activeRoomId = '';

  void handleFloorSelected(String floorId) {
    setState(() {
      activeFloorId = floorId;
      activeRoomId = ''; // Reset active room when floor changes
    });
  }

  void handleRoomSelected(String roomId) {
    setState(() {
      activeRoomId = roomId;
    });
    // Fetch devices for the selected room
    context.read<DevicesBloc>().add(FetchDevices(roomId: roomId));
  }

  Future<void> _refreshData() async {
    // Refresh devices data
    if (activeRoomId.isNotEmpty) {
      context.read<DevicesBloc>().add(FetchDevices(roomId: activeRoomId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppColor.backgroundColorgradient,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          bottomNavigationBar: const CustomNavigationBar(),
          body: RefreshIndicator(
            onRefresh: _refreshData,
            color: AppColor.whiteColor,
            backgroundColor: Colors.transparent,
            child: SafeArea(
              child: Padding(
                padding: AppPadding.pagePadding(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenSize.height * 0.02),
                    Text(
                      'All Devices',
                      style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: AppFontSizes.pageHeading,
                        fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    FloorRoomSelector(
                      onFloorSelected: handleFloorSelected,
                      onRoomSelected: handleRoomSelected,
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    Expanded(
                        child: BlocBuilder<DevicesBloc, DevicesState>(
                        builder: (context, state) {
                          if (state is DevicesLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                            } else if (state is DevicesLoaded) {
                              return Center(
                                child: Text(
                                  'Nothing to show here.\nGo to Devices or Nodes page and add a device to favorites list.',
                                  style: TextStyle(
                                    color: AppColor.whiteColor,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            } 
                           else {
                            return Container();
                          }
                        }
                      )
                    ),
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