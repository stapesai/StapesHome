import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationState(NavigationItem.home)) {
    on<NavigationItemSelected>(_onNavigationItemSelected);
  }

  void _onNavigationItemSelected(NavigationItemSelected event, Emitter<NavigationState> emit) {
    emit(NavigationState(event.navigationItem));
  }
}
