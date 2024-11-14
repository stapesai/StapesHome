abstract class NavigationEvent {}

enum NavigationItem { home, devices, nodes, profile }

class NavigationItemSelected extends NavigationEvent {
  final NavigationItem navigationItem;
  NavigationItemSelected(this.navigationItem);
}
