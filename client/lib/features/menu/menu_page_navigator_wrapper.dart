import 'package:client/features/home/current_route.dart';
import 'package:client/router.dart';
import 'package:flutter/material.dart';

class MenuPageNavigatorWrapper extends StatelessWidget {
  MenuPageNavigatorWrapper({super.key});

  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: generateMenuScreenRoute,
      initialRoute: MenuPageRoute.dishListRoute,
      // observers: [
      //   CurrentRouteNavigatorObserver()
      // ],
    );
  }
}
