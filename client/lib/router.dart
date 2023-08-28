import 'package:client/features/employees/employees.dart';
import 'package:client/features/orders/orders.dart';
import 'package:client/features/settings/settings.dart';
import 'package:client/features/stats/stats_page.dart';
import 'package:client/features/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:client/features/store/store.dart';
import 'package:client/features/supplys/supplys.dart';
import 'package:client/features/menu/menu.dart';
import 'package:page_transition/page_transition.dart';


class AppRoute {
  static const home = '/';
}

class HomeScreenPage {
  static const stats = 'stats';
  static const store = 'store';
  static const orders = 'orders';
  static const menu = 'menu';
  static const employees = 'employees';
  static const supplys = 'supplys';
  static const settings = 'settings';
}


Route generateHomeScreenRoute(RouteSettings settings) {
  final page = switch (settings.name) {
    HomeScreenPage.stats => const DashboardPage(),
    HomeScreenPage.store => const StorePage(),
    HomeScreenPage.orders => const OrdersPage(),
    HomeScreenPage.menu => MenuPage(),
    HomeScreenPage.employees => const Employees(),
    HomeScreenPage.supplys => const SupplysPage(),
    HomeScreenPage.settings => const SettingsPage(),
    _ => const Material(child: Center(child: Text('Page not found')))
  };

  return PageTransition(
    settings: settings,
    type: PageTransitionType.fade,
    duration: const Duration(milliseconds: 200),
    child: page,
  );
}

Route generateRootRoute(RouteSettings settings) {
  final page = switch (settings.name) {
    AppRoute.home => HomeScreen(),
    _ => Scaffold(appBar: AppBar(title: const Text('Screen not found')))
  };

  return MaterialPageRoute(
    settings: settings,
    builder: (context) => page
  );
}