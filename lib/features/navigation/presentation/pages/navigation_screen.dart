import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/features/dev/presentation/pages/dev_test_page.dart';
import 'package:stapes_home/features/dev/presentation/pages/dev_user_details_show.dart';
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
  // double _dragStart = 0.0;
  // double _dragOffset = 0.0;

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
    // Get screen width
    // final double screenWidth = MediaQuery.of(context).size.width;

    // TODO: i dont understand why we can't use BlocProvider directly here.
    // When the page is repainted, BlocProvider should not rerender as the Scaffold is its child.
    // So, on any event maximum Scaffold will rerender.
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
          // FIXME: Refer whatsapp and see the animation when we swipe the page. Implement the same here.
          // Probabily that can be done by changing the physics of the PageView.
          // FIXME: I am not able to swipe pages when using PhoneLink to connect to phone via PC using ADB.
          //   body: GestureDetector(
          //     onHorizontalDragStart: (details) {
          //       _dragStart = details.globalPosition.dx;
          //       _dragOffset = _pageController.offset;
          //     },
          //     onHorizontalDragUpdate: (details) {
          //       final currentDrag = details.globalPosition.dx;
          //       final dragDifference = currentDrag - _dragStart;

          //       // Calculate new position while dragging
          //       final newOffset = _dragOffset - dragDifference;
          //       final maxOffset = screenWidth * (NavigationTab.values.length - 1);

          //       // Clamp the offset to prevent overscrolling
          //       final clampedOffset = newOffset.clamp(0.0, maxOffset);

          //       // Update page position in real-time
          //       _pageController.jumpTo(clampedOffset);
          //     },
          //     onHorizontalDragEnd: (details) {
          //       final dragEnd = details.primaryVelocity ?? 0;
          //       final dragDistance = details.globalPosition.dx - _dragStart;
          //       final currentPage = (_pageController.offset / screenWidth).round();
          //       int targetPage = currentPage;

          //       if (dragDistance.abs() > screenWidth / 2 || dragEnd.abs() > 800) {
          //         if (dragDistance < 0 && currentPage < NavigationTab.values.length - 1) {
          //           targetPage = currentPage + 1;
          //         } else if (dragDistance > 0 && currentPage > 0) {
          //           targetPage = currentPage - 1;
          //         }
          //       }

          //       final selectedItem = NavigationTab.values[targetPage];
          //       _navigationBloc.add(NavigationPageSwiped(selectedItem));
          //     },
          // child: PageView(
          body: PageView(
            controller: _pageController,
            // physics: const BouncingScrollPhysics(),
            // physics: const ClampingScrollPhysics(),
            // This will disable the swipe gesture of the PageView.
            // physics: const NeverScrollableScrollPhysics(),

            onPageChanged: (index) {
              // Update navigation state when page is swiped
              if (!_isHandlingTap) {
                final selectedItem = NavigationTab.values[index];
                // context.read<NavigationBloc>().add(NavigationItemSelected(selectedItem));
                _navigationBloc.add(NavigationPageSwiped(selectedItem));
              }
            },
            children: const [
              // When using navigation shell:
              // I have tried to take the chidren from the navigationShell, but it doesn't work
              // Now, this is not in use as we are using PageView
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
          // ),
          bottomNavigationBar: const CustomNavigationBar(),
        ),
      ),
    );
  }
}
