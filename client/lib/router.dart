import 'package:client/features/employees/employees.dart';
import 'package:client/features/menu/add_dish/add_dish.dart';
import 'package:client/features/menu/add_dish_group/add_dish_group_dialog.dart';
import 'package:client/features/menu/dish_details/dish_details.dart';
import 'package:client/features/menu/menu_page_navigator_wrapper.dart';
import 'package:client/features/orders/orders.dart';
import 'package:client/features/settings/settings.dart';
import 'package:client/features/stats/stats_page.dart';
import 'package:client/features/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:client/features/store/store.dart';
import 'package:client/features/supplys/supplys.dart';
import 'package:client/features/menu/menu.dart';
import 'package:page_transition/page_transition.dart';

import 'features/menu/add_dish/add_dish_page_mode.dart';


class AppRoute {
  static const home = '/';
}


/// home screen drawer tabs
class HomeScreenPage {
  /// /stats
  static const stats = 'stats';
  /// /store
  static const store = 'store';
  /// /orders
  static const orders = 'orders';
  /// /menu
  static const menu = 'menu';
  /// /employees
  static const employees = 'employees';
  /// /supplys
  static const supplys = 'supplys';
  /// /settings
  static const settings = 'settings';
}


/// different routes of the menu tab
class MenuPageRoute {
  /// /menu/
  static const dishListRoute = '/';
  /// /menu/add-dish
  static const addDishRoute = 'add-dish';
  /// /menu/add-group
  static const addGroupRoute = 'add-group';
  /// /menu/34
  static String dishDetailsRoute(int dishId) => dishId.toString();
  /// /menu/34/edit
  static String dishEditRoute(int dishId) => '${dishDetailsRoute(dishId)}/edit';

  /// distinguish dishDetails route
  static final dishDetailsRegExp = RegExp(r'^\d+$');
  /// distinguish dishEdit route
  static final dishEditRegExp = RegExp(r'^\d+/edit$');
}


Route generateMenuScreenRoute(RouteSettings settings) {
  if (settings.name == MenuPageRoute.addDishRoute) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => const AddDishPage()
    );
  } else if (settings.name == MenuPageRoute.dishListRoute) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => MenuPage()
    );
  } else if (settings.name == MenuPageRoute.addGroupRoute) {
    return RawDialogRoute(
      settings: settings,
      pageBuilder: (context, _, __) => AddDishGroupDialog()
    );
  } else if (MenuPageRoute.dishDetailsRegExp.hasMatch(settings.name ?? '')) {
    return MaterialPageRoute(
        settings: settings,
        builder: (context) => DishDetalsPage(
          dishId: (settings.arguments as DishDetailsRouteArgs).dishId
        )
    );
  } else if (MenuPageRoute.dishEditRegExp.hasMatch(settings.name ?? '')) {
    return MaterialPageRoute(
        settings: settings,
        builder: (context) => AddDishPage(
          mode: AddDishPageMode.edit,
          dishToEdit: (settings.arguments as EditDishRouteArgs).dish
        )
    );
  }
  return MaterialPageRoute(
    settings: settings,
    builder: (context) => const Material(child: Center(child: Text('Page not found')))
  );
}


Route generateHomeScreenRoute(RouteSettings settings) {
  final page = switch (settings.name) {
    HomeScreenPage.stats => const DashboardPage(),
    HomeScreenPage.store => const StorePage(),
    HomeScreenPage.orders => const OrdersPage(),
    HomeScreenPage.menu => MenuPageNavigatorWrapper(),
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