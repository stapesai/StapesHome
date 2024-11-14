import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stapes_home/features/navigation/presentation/blocs/navigation_bloc.dart';
import 'package:stapes_home/features/navigation/presentation/blocs/navigation_event.dart';
import 'package:stapes_home/features/navigation/presentation/blocs/navigation_state.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  BottomNavigationBarItem _buildNavigationItem(
    String label,
    String inactiveIcon,
    String activeIcon,
    bool isActive,
  ) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        isActive ? activeIcon : inactiveIcon,
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return BottomNavigationBar(
          currentIndex: state.selectedItem.index,
          onTap: (index) {
            // Emit event when user clicks on a button
            final selectedItem = NavigationItem.values[index];
            context.read<NavigationBloc>().add(NavigationItemSelected(selectedItem));
          },
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          items: [
            _buildNavigationItem(
              'Home',
              'assets/icons/navbar/home.svg',
              'assets/icons/navbar/home-active.svg',
              state.selectedItem == NavigationItem.home,
            ),
            _buildNavigationItem(
              'Devices',
              'assets/icons/navbar/devices.svg',
              'assets/icons/navbar/devices-active.svg',
              state.selectedItem == NavigationItem.devices,
            ),
            _buildNavigationItem(
              'Nodes',
              'assets/icons/navbar/nodes.svg',
              'assets/icons/navbar/nodes-active.svg',
              state.selectedItem == NavigationItem.nodes,
            ),
            _buildNavigationItem(
              'Settings',
              'assets/icons/navbar/profile.svg',
              'assets/icons/navbar/profile-active.svg',
              state.selectedItem == NavigationItem.profile,
            ),
          ],
        );
      },
    );
  }
}
