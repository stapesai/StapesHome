enum NavigationTab { home, devices, nodes, settings }

class NavigationState {
  final NavigationTab currentTab;
  NavigationState(this.currentTab);
}
