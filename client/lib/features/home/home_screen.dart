import 'package:client/features/home/current_route.dart';
import 'package:client/router.dart';
import 'package:client/utils/sizes.dart';
import 'package:flutter/material.dart';

mixin RouteNavigationDestination {
  String get routeName;
}

class RouteNavigationDrawerDestination 
    extends NavigationDrawerDestination 
    with RouteNavigationDestination {
  @override
  final String routeName;

  const RouteNavigationDrawerDestination({
    required this.routeName, 
    required Widget icon, 
    required Widget label,
    Key? key,
    Widget? selectedIcon
  }) : super(key: key, icon: icon, label: label, selectedIcon: selectedIcon);

}

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final navigatorKey = GlobalKey<NavigatorState>();

  static HomeScreen? of(BuildContext context) {
    return context.findAncestorWidgetOfExactType<HomeScreen>();
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int currentRoute = 0;

  final routes = const [
    RouteNavigationDrawerDestination(
      routeName: HomeScreenPage.stats,
      icon: Icon(Icons.analytics_outlined),
      selectedIcon: Icon(Icons.analytics),
      label: Text('stats')
    ),
    RouteNavigationDrawerDestination(
      routeName: HomeScreenPage.store,
      icon: Icon(Icons.local_grocery_store_outlined),
      selectedIcon: Icon(Icons.local_grocery_store),
      label: Text('store')
    ),
    RouteNavigationDrawerDestination(
      routeName: HomeScreenPage.orders,
      icon: Icon(Icons.note_alt_outlined),
      selectedIcon: Icon(Icons.note_alt),
      label: Text('orders')
    ),
    RouteNavigationDrawerDestination(
      routeName: HomeScreenPage.menu,
      icon: Icon(Icons.book_outlined),
      selectedIcon: Icon(Icons.book),
      label: Text('menu')
    ),
    RouteNavigationDrawerDestination(
      routeName: HomeScreenPage.employees,
      icon: Icon(Icons.people_outline),
      selectedIcon: Icon(Icons.people),
      label: Text('employees')
    ),
    RouteNavigationDrawerDestination(
      routeName: HomeScreenPage.supplys,
      icon: Icon(Icons.local_shipping_outlined),
      selectedIcon: Icon(Icons.local_shipping),
      label: Text('supplies')
    ),
    RouteNavigationDrawerDestination(
      routeName: HomeScreenPage.settings,
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      label: Text('settings')
    ),
  ];

  void onDestinationSelected(i) {
    widget.navigatorKey.currentState!
      .pushNamedAndRemoveUntil(routes[i].routeName, (route) => false);
    widget.scaffoldKey.currentState!.closeDrawer();
    setState(() => currentRoute = i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldKey,
      drawer: NavigationDrawer(
        selectedIndex: currentRoute,
        onDestinationSelected: onDestinationSelected,
        children: [
          h16gap, 
          for (final dest in routes) ...[
            dest.routeName == HomeScreenPage.settings ? const Divider() : shrink, 
            dest,
          ]
        ],
      ),
      body: Navigator(
        key: widget.navigatorKey,
        initialRoute: HomeScreenPage.stats,
        onGenerateRoute: generateHomeScreenRoute,
      )
    );
  }
}