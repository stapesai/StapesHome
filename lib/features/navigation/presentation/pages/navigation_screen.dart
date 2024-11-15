import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/features/dev/dev_test_page.dart';
import 'package:stapes_home/features/dev/dev_user_details_show.dart';
import 'package:stapes_home/features/navigation/presentation/blocs/navigation_bloc.dart';
import 'package:stapes_home/features/navigation/presentation/blocs/navigation_event.dart';
import 'package:stapes_home/features/navigation/presentation/blocs/navigation_state.dart';
import 'package:stapes_home/features/navigation/presentation/widgets/custom_navigation_bar.dart';

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
  bool _isHandlingTap = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _navigationBloc = NavigationBloc();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _navigationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _navigationBloc,
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
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: PageView(
            controller: _pageController,
            // physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              // Update navigation state when page is swiped
              if (!_isHandlingTap) {
                final selectedItem = NavigationTab.values[index];
                // context.read<NavigationBloc>().add(NavigationItemSelected(selectedItem));
                _navigationBloc.add(NavigationPageSwiped(selectedItem));
              }
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
