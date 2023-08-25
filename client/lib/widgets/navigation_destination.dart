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

class RouteNavigationRailDestination 
    extends NavigationRailDestination 
    with RouteNavigationDestination {
  @override
  final String routeName;

  const RouteNavigationRailDestination({
    required this.routeName, 
    required Widget icon, 
    required Widget label,
    Key? key,
    Widget? selectedIcon
  }) : super(icon: icon, label: label, selectedIcon: selectedIcon);
}