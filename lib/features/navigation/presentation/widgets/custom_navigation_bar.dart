import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stapes_home/core/theme/app_colors.dart';
import 'package:stapes_home/features/navigation/presentation/blocs/navigation_bloc.dart';
import 'package:stapes_home/features/navigation/presentation/blocs/navigation_event.dart';
import 'package:stapes_home/features/navigation/presentation/blocs/navigation_state.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  Widget _buildNavigationItem({
    required String label,
    required String inactiveIcon,
    required String activeIcon,
    required bool isSelected,
    required VoidCallback onTap,
    required double height,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        width: 70,
        height: height / 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: SvgPicture.asset(
                isSelected ? activeIcon : inactiveIcon,
                colorFilter: ColorFilter.mode(
                  isSelected ? Theme.of(context).primaryColor : Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),   
              child: Material(
                type: MaterialType.transparency,
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Theme.of(context).primaryColor : Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double navBarHeight = 70.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = screenWidth / 4;

    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: navBarHeight,
          child: Column(
            children: [
              // Indicator line
              SizedBox(
                width: screenWidth,
                height: 2,
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      left: itemWidth * state.currentTab.index,
                      child: Container(
                        width: itemWidth,
                        height: 2,
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Navigation items
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavigationItem(
                        label: 'Home',
                        inactiveIcon: 'assets/icons/navbar/home.svg',
                        activeIcon: 'assets/icons/navbar/home-active.svg',
                        isSelected: state.currentTab == NavigationTab.values[0],
                        onTap: () =>
                            context.read<NavigationBloc>().add(NavigationItemSelected(NavigationTab.values[0])),
                        height: navBarHeight,
                        context: context,
                      ),
                      _buildNavigationItem(
                        label: 'Devices',
                        inactiveIcon: 'assets/icons/navbar/devices.svg',
                        activeIcon: 'assets/icons/navbar/devices-active.svg',
                        isSelected: state.currentTab == NavigationTab.values[1],
                        onTap: () =>
                            context.read<NavigationBloc>().add(NavigationItemSelected(NavigationTab.values[1])),
                        height: navBarHeight,
                        context: context,
                      ),
                      _buildNavigationItem(
                        label: 'Nodes',
                        inactiveIcon: 'assets/icons/navbar/nodes.svg',
                        activeIcon: 'assets/icons/navbar/nodes-active.svg',
                        isSelected: state.currentTab == NavigationTab.values[2],
                        onTap: () =>
                            context.read<NavigationBloc>().add(NavigationItemSelected(NavigationTab.values[2])),
                        height: navBarHeight,
                        context: context,
                      ),
                      _buildNavigationItem(
                        label: 'Settings',
                        inactiveIcon: 'assets/icons/navbar/profile.svg',
                        activeIcon: 'assets/icons/navbar/profile-active.svg',
                        isSelected: state.currentTab == NavigationTab.values[3],
                        onTap: () =>
                            context.read<NavigationBloc>().add(NavigationItemSelected(NavigationTab.values[3])),
                        height: navBarHeight,
                        context: context,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}