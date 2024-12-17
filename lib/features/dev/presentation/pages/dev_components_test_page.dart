// File: lib/features/dev/presentation/pages/dev_components_test_page.dart

import 'package:flutter/material.dart';
import 'package:stapes_home/core/models/device_model.dart';
import 'package:stapes_home/core/models/node_model.dart';
import 'package:stapes_home/features/common/presentation/widgets/iot/light_widget.dart';
import 'package:stapes_home/features/common/presentation/widgets/iot/node_widget.dart';
import 'package:stapes_home/features/common/presentation/widgets/skeletons/iot_device_skel.dart';
import 'package:stapes_home/features/common/presentation/widgets/skeletons/node_skel.dart';

class DevComponentsTestPage extends StatelessWidget {
  const DevComponentsTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  NodeComponentSkeleton(),
                  NodeComponentWidget(
                    node: NodeModel(
                      id: 'test_id',
                      name: 'Test Node',
                      numEntities: 3,
                      roomId: 'test_room_id',
                      hardwareChip: 'TEST_CHIP',
                      hardwareVersion: 'TEST_VERSION',
                      firmwareVersion: 'TEST_FIRMWARE',
                    ),
                  ),
                  IotDevicesSkeleton(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      LightComponentWidget(
                        device: DeviceModel(
                          id: 'test_id',
                          nodeId: 'test_node_id',
                          name: 'Test Light',
                          type: 'light',
                          channelId: 1,
                        ),
                        onToggle: () {},
                        isActivated: true,
                      ),
                      LightComponentWidget(
                        device: DeviceModel(
                          id: 'test_id',
                          nodeId: 'test_node_id',
                          name: 'Test Light',
                          type: 'light',
                          channelId: 1,
                        ),
                        onToggle: () {},
                        isActivated: false,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
