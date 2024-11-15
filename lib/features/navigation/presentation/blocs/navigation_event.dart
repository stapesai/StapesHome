import 'package:stapes_home/features/navigation/presentation/blocs/navigation_state.dart';

abstract class NavigationEvent {}

class NavigationItemSelected extends NavigationEvent {
  final NavigationTab navigationItem;
  NavigationItemSelected(this.navigationItem);
}

class NavigationPageSwiped extends NavigationEvent {
  final NavigationTab navigationItem;
  NavigationPageSwiped(this.navigationItem);
}
