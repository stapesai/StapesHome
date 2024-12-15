import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationState(NavigationTab.home)) {
    on<NavigationItemSelected>(_onNavigationItemSelected);
    on<NavigationPageSwiped>(_onNavigationPageSwiped);
  }

  void _onNavigationItemSelected(NavigationItemSelected event, Emitter<NavigationState> emit) {
    print('Item selected: ${event.navigationItem}');
    emit(NavigationState(event.navigationItem));
  }

  void _onNavigationPageSwiped(NavigationPageSwiped event, Emitter<NavigationState> emit) {
    print('Page swiped to: ${event.navigationItem}');
    emit(NavigationState(event.navigationItem));
  }
}
