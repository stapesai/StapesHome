import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stapes_home/features/navigation/presentation/blocs/navigation_bloc.dart';
import 'package:stapes_home/features/navigation/presentation/blocs/navigation_event.dart';
import 'package:stapes_home/features/navigation/presentation/blocs/navigation_state.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  Widget _buildNavigationItem(
    String label,
    String inactiveIcon,
    String activeIcon,
  ) {
    return NavigationDestination(
      icon: SvgPicture.asset(inactiveIcon),
      selectedIcon: SvgPicture.asset(activeIcon),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.all(
            TextStyle(color: Colors.white),
          ),
        ),
      ),
      child: BlocBuilder<NavigationBloc, NavigationState>(
        // buildWhen: (previous, current) => previous.currentTab != current.currentTab,
        builder: (context, state) {
          return NavigationBar(
            backgroundColor: Colors.transparent,
            indicatorColor: Colors.transparent,
            shadowColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            // This means that the label will only be shown when the button is selected, otherwise it will be hidden
            // Options: alwaysShow, alwaysHide, onlyShowSelected
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            // This is the duration of the animation when the user clicks on a button.
            // The old button text will fade out and the new button text will fade in.
            // But the color of the icon will change instantly.
            animationDuration: const Duration(milliseconds: 200),
            selectedIndex: state.currentTab.index,
            onDestinationSelected: (index) {
              // Emit event when user clicks on a button
              final selectedItem = NavigationTab.values[index];
              context.read<NavigationBloc>().add(NavigationItemSelected(selectedItem));
            },
            destinations: [
              _buildNavigationItem(
                'Home',
                'assets/icons/navbar/home.svg',
                'assets/icons/navbar/home-active.svg',
              ),
              _buildNavigationItem(
                'Devices',
                'assets/icons/navbar/devices.svg',
                'assets/icons/navbar/devices-active.svg',
              ),
              _buildNavigationItem(
                'Nodes',
                'assets/icons/navbar/nodes.svg',
                'assets/icons/navbar/nodes-active.svg',
              ),
              _buildNavigationItem(
                'Settings',
                'assets/icons/navbar/profile.svg',
                'assets/icons/navbar/profile-active.svg',
              ),
            ],
          );
        },
      ),
    );
  }
}
