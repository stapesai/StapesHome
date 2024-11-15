import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stapes_home/core/constants/app_route_constants.dart';
import 'package:stapes_home/features/dev/dev_test_page.dart';
import 'package:stapes_home/features/dev/dev_user_details_show.dart';
import 'package:stapes_home/features/navigation/presentation/blocs/navigation_bloc.dart';
import 'package:stapes_home/features/navigation/presentation/blocs/navigation_event.dart';
import 'package:stapes_home/features/navigation/presentation/blocs/navigation_state.dart';
import 'package:stapes_home/features/navigation/presentation/widgets/custom_navigation_bar.dart';

class NavigationScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const NavigationScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationBloc(),
      child: BlocListener<NavigationBloc, NavigationState>(
        listener: (context, state) {
          final index = NavigationTab.values.indexOf(state.currentTab);
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
          );
          widget.navigationShell.goBranch(index);
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              context.read<NavigationBloc>().add(NavigationPageSwiped(NavigationTab.values[index]));
            },
            children: const [
              // TODO: I have tried to take the chidren from the navigationShell, but it doesn't work
              // widget.navigationShell.branches[0],
              // widget.navigationShell.branches[1],
              // widget.navigationShell.branches[2],
              // widget.navigationShell.branches[3],
              DevUserDetailsScreen(),
              DevTestPage(text: 'Devices Page'),
              DevTestPage(text: 'Nodes Page'),
              DevTestPage(text: 'Settings Page'),
            ],
          ),
          bottomNavigationBar: const CustomNavigationBar(),
        ),
      ),
    );
  }
}
