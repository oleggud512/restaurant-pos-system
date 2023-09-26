import 'package:client/l10n/localizations_context_ext.dart';
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

  final routes = [
    HomeScreenPage.stats,
    HomeScreenPage.store,
    HomeScreenPage.orders,
    HomeScreenPage.menu,
    HomeScreenPage.employees,
    HomeScreenPage.supplys,
    HomeScreenPage.settings,
  ];

  List<RouteNavigationDrawerDestination> get displayRoutes => 
    routes.map((route) => switch (route) {
      HomeScreenPage.stats => RouteNavigationDrawerDestination(
        routeName: route,
        icon: const Icon(Icons.analytics_outlined),
        selectedIcon: const Icon(Icons.analytics),
        label: Text(context.ll!.stats_page_title)
      ),
      HomeScreenPage.store => RouteNavigationDrawerDestination(
        routeName: route,
        icon: const Icon(Icons.local_grocery_store_outlined),
        selectedIcon: const Icon(Icons.local_grocery_store),
        label: Text(context.ll!.store_page_title)
      ),
      HomeScreenPage.orders => RouteNavigationDrawerDestination(
        routeName: route,
        icon: const Icon(Icons.note_alt_outlined),
        selectedIcon: const Icon(Icons.note_alt),
        label: Text(context.ll!.orders_page_title)
      ),
      HomeScreenPage.menu => RouteNavigationDrawerDestination(
        routeName: route,
        icon: const Icon(Icons.book_outlined),
        selectedIcon: const Icon(Icons.book),
        label: Text(context.ll!.menu_page_title)
      ),
      HomeScreenPage.employees => RouteNavigationDrawerDestination(
        routeName: route,
        icon: const Icon(Icons.people_outline),
        selectedIcon: const Icon(Icons.people),
        label: Text(context.ll!.employees_page_title)
      ),
      HomeScreenPage.supplys => RouteNavigationDrawerDestination(
        routeName: route,
        icon: const Icon(Icons.local_shipping_outlined),
        selectedIcon: const Icon(Icons.local_shipping),
        label: Text(context.ll!.supplies_page_title)
      ),
      HomeScreenPage.settings => RouteNavigationDrawerDestination(
        routeName: route,
        icon: const Icon(Icons.settings_outlined),
        selectedIcon: const Icon(Icons.settings),
        label: Text(context.ll!.settings_page_title)
      ),
      _ => const RouteNavigationDrawerDestination(
        routeName: 'unknown',
        icon: Icon(Icons.question_mark),
        selectedIcon: Icon(Icons.question_mark),
        label: Text('unknown')
      )
    }).toList();


  void onDestinationSelected(i) {
    widget.navigatorKey.currentState!
      .pushNamedAndRemoveUntil(routes[i], (route) => false);
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
          for (final dest in displayRoutes) ...[
            dest.routeName == HomeScreenPage.settings 
              ? const Divider() 
              : shrink, 
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