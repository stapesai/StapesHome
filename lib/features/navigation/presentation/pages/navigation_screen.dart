import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stapes_home/core/constants/app_route_constants.dart';
import 'package:stapes_home/features/navigation/presentation/blocs/navigation_bloc.dart';
import 'package:stapes_home/features/navigation/presentation/blocs/navigation_event.dart';
import 'package:stapes_home/features/navigation/presentation/blocs/navigation_state.dart';
import '../widgets/custom_navigation_bar.dart';

class NavigationScreen extends StatelessWidget {
  final Widget child;

  const NavigationScreen({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationBloc(),
      child: BlocListener<NavigationBloc, NavigationState>(
        listener: (context, state) {
          // Perform navigation when state changes
          switch (state.selectedItem) {
            case NavigationItem.home:
              context.go(AppRouteConstants.home.routePath);
              break;
            case NavigationItem.devices:
              context.go(AppRouteConstants.devices.routePath);
              break;
            case NavigationItem.nodes:
              context.go(AppRouteConstants.nodes.routePath);
              break;
            case NavigationItem.settings:
              context.go(AppRouteConstants.settings.routePath);
              break;
          }
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: child,
          bottomNavigationBar: const CustomNavigationBar(),
        ),
      ),
    );
  }
}
