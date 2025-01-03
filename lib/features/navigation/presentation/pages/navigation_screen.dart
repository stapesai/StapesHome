// File: lib/features/navigation/presentation/pages/navigation_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/websocket/websocket_bloc.dart';
import 'package:stapes_home/core/websocket/websocket_event.dart';
import 'package:stapes_home/features/dev/presentation/pages/dev_components_test_page.dart';
import 'package:stapes_home/features/dev/presentation/pages/dev_floor_room_sel.dart';
import 'package:stapes_home/features/devices/presentation/pages/devices.dart';
import 'package:stapes_home/features/home/presentation/pages/home.dart';
import 'package:stapes_home/features/navigation/presentation/blocs/navigation_bloc.dart';
import 'package:stapes_home/features/navigation/presentation/blocs/navigation_event.dart';
import 'package:stapes_home/features/navigation/presentation/blocs/navigation_state.dart';
import 'package:stapes_home/features/navigation/presentation/mixin/keep_alive_mixin.dart';
import 'package:stapes_home/features/dev/presentation/pages/dev_websocket_messages_test.dart';
import 'package:stapes_home/features/navigation/presentation/widgets/custom_navigation_bar.dart';
import 'package:stapes_home/features/nodes/presentation/pages/nodes.dart';
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

  final List<Widget> _pages = const [
    // When using navigation shell:
    // I have tried to take the chidren from the navigationShell, but it doesn't work
    // Now, this is not in use as we are using PageView
    // widget.navigationShell.branches[0],
    // widget.navigationShell.branches[1],
    // widget.navigationShell.branches[2],
    // widget.navigationShell.branches[3],
    // CreateRoomPage(floorId: 'test'),
    KeepAlivePage(child: HomePage()),
    KeepAlivePage(child: DevicesPage()),
    KeepAlivePage(child: NodesPage()),
    // DevFloorRoomSelPage(),
    QrScannerScreen(),
    // DevComponentsTestPage(),
    // KeepAlivePage(child: HomeScreen()),
    KeepAlivePage(child: DevTestWebsocketMessagesPage(page: 'home')),
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
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          // FIXME: I am not able to swipe pages when using PhoneLink to connect to phone via PC using ADB.

          body: PageView(
            physics: ClampingScrollPhysics(),
            controller: _pageController,
            children: _pages,
          ),
          // ),
          bottomNavigationBar: const CustomNavigationBar(),
        ),
      ),
    );
  }
}
