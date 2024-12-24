// File: lib/features/navigation/presentation/pages/navigation_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/websocket/websocket_bloc.dart';
import 'package:stapes_home/core/websocket/websocket_event.dart';
import 'package:stapes_home/features/dev/presentation/pages/dev_components_test_page.dart';
import 'package:stapes_home/features/dev/presentation/pages/dev_floor_room_sel.dart';
import 'package:stapes_home/features/home/presentation/pages/home.dart';
import 'package:stapes_home/features/iot_provisioning/presentation/pages/iot_provisioning.dart';
import 'package:stapes_home/features/navigation/presentation/blocs/navigation_bloc.dart';
import 'package:stapes_home/features/navigation/presentation/blocs/navigation_event.dart';
import 'package:stapes_home/features/navigation/presentation/blocs/navigation_state.dart';
import 'package:stapes_home/features/navigation/presentation/mixin/keep_alive_mixin.dart';
import 'package:stapes_home/features/dev/presentation/pages/dev_websocket_messages_test.dart';
import 'package:stapes_home/features/navigation/presentation/widgets/custom_navigation_bar.dart';
import 'package:stapes_home/features/scanner/data/models/pair_iot_node_qr_model.dart';
import 'package:stapes_home/features/scanner/presentation/pages/qr_scanner.dart';

class NavigationScreen extends StatefulWidget {
  // final StatefulNavigationShell navigationShell;

  const NavigationScreen({
    super.key,
    // required this.navigationShell,
  });

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  late final PageController _pageController;
  late final NavigationBloc _navigationBloc;
  late final WebsocketBloc _websocketBloc;
  bool _isHandlingTap = false;
  // double _dragStart = 0.0;
  // double _dragOffset = 0.0;
//   static final fakeIotQrModel = IotQrModel(
//   deviceName: "IoT_Device_1234",
//   serviceUuid: "0000180a-0000-1000-8000-00805f9b34fb",
//   configCharacteristicUuid: "00002a29-0000-1000-8000-00805f9b34fb",
//   versionCharacteristicUuid: "00002a28-0000-1000-8000-00805f9b34fb",
//   checkWiFiCredentialsCharacteristicUuid: "00002a27-0000-1000-8000-00805f9b34fb",
// );

  final List<Widget> _pages = [
    // When using navigation shell:
    // I have tried to take the chidren from the navigationShell, but it doesn't work
    // Now, this is not in use as we are using PageView
    // widget.navigationShell.branches[0],
    // widget.navigationShell.branches[1],
    // widget.navigationShell.branches[2],
    // widget.navigationShell.branches[3],
    // CreateRoomPage(floorId: 'test'),
    const DevFloorRoomSelPage(),
    QrScannerScreen(),
    // IoTProvisioningScreen(
    //   qrData: fakeIotQrModel,
    // ),
    const DevComponentsTestPage(),
    const KeepAlivePage(child: HomeScreen()),
    // KeepAlivePage(child: HomeScreen()),
    const KeepAlivePage(child: DevTestWebsocketMessagesPage(page: 'home')),
    // KeepAlivePage(child: DevTestWebsocketMessagesPage(page: 'devices')),
    // KeepAlivePage(child: DevTestWebsocketMessagesPage()),
    // KeepAlivePage(child: DevTestWebsocketMessagesPage()),
    // DevTestPage(text: 'Nodes Page'),
    // KeepAlivePage(child: DevUserDetailsScreen()),
    // DevTestPage(text: 'Devices Page'),
    // DevTestPage(text: 'Settings Page'),
  ];

  @override
  void initState() {
    print('NavigationScreen initState');
    super.initState();
    _pageController = PageController();
    _navigationBloc = NavigationBloc();
    _websocketBloc = WebsocketBloc();
    _websocketBloc.add(ConnectWebsocketEvent());
    _pageController.addListener(_handlePageChange);
  }

  @override
  void dispose() {
    print('NavigationScreen dispose');
    _pageController.dispose();
    _navigationBloc.close();
    _websocketBloc.add(DisconnectWebsocketEvent());
    _websocketBloc.close();
    super.dispose();
  }

  void _handlePageChange() {
    if (_isHandlingTap) return;

    final pageIndex = _pageController.page?.round() ?? 0;
    // print('Page Index: $pageIndex');
    // print('Page Controller Page: ${_pageController.page}');
    // print('Page Controller Position: ${_pageController.position}');

    // FIXME: this has very bad performance. It is called on every pixel change. See debug console.
    // Ensure updates only happen when the page animation has fully settled
    if (pageIndex == _pageController.page) {
      final selectedItem = NavigationTab.values[pageIndex];
      _navigationBloc.add(NavigationPageSwiped(selectedItem));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width
    // final double screenWidth = MediaQuery.of(context).size.width;

    // TODO: i dont understand why we can't use BlocProvider directly here.
    // When the page is repainted, BlocProvider should not rerender as the Scaffold is its child.
    // So, on any event maximum Scaffold will rerender.

    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _navigationBloc),
          BlocProvider.value(value: _websocketBloc),
        ],
        // value: _navigationBloc,
        // return BlocProvider(
        //   create: (context) => NavigationBloc(),
        child: BlocListener<NavigationBloc, NavigationState>(
          listener: (context, state) {
            final index = NavigationTab.values.indexOf(state.currentTab);

            // Animated Scrolling
            _isHandlingTap = true;
            _pageController
                .animateToPage(
                  index,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeInOut,
                )
                .then(
                  (_) => _isHandlingTap = false,
                );

            // Jump to page without animation
            // _pageController.jumpToPage(index);

            // Don't know its functionallity - used when using StatefulShellRoute.indexedStack
            // widget.navigationShell.goBranch(index);
          },
          child: BlocBuilder<NavigationBloc, NavigationState>(
            builder: (context, state) {
              // Get the current page index
              final currentIndex = NavigationTab.values.indexOf(state.currentTab);

              return Scaffold(
                backgroundColor: Colors.transparent,
                body: PageView(
                  physics: ClampingScrollPhysics(),
                  controller: _pageController,
                  children: _pages,
                ),
                // Hide bottom navigation when QR screen is shown (index 1)
                bottomNavigationBar: currentIndex == 1 ? null : const CustomNavigationBar(),
              );
            },
          ),
        ));
  }
}
