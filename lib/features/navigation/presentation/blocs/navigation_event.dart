abstract class NavigationEvent {}

enum NavigationItem { home, devices, nodes, settings }

class NavigationItemSelected extends NavigationEvent {
  final NavigationItem navigationItem;
  NavigationItemSelected(this.navigationItem);
}
