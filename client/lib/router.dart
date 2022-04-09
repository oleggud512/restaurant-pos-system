import 'package:client/orders/orders.dart';
import 'package:client/settings/settings.dart';
import 'package:client/stats/stats_page.dart';
import 'package:flutter/material.dart';
import 'package:client/main.dart';
import 'package:client/store/store.dart';
import 'package:client/supplys/supplys.dart';
import 'package:client/menu/add_dish/add_dish.dart';
import 'package:client/menu/menu.dart';

class MyRouter {
  Route onGenerateRoute(RouteSettings settings) {
    //final GlobalKey<ScaffoldState> key = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute<void>(
          settings: const RouteSettings(name: '/'),
          builder: (context) => StatsPage()
        );
      case '/store':
        return MaterialPageRoute<void>(
          settings: const RouteSettings(name: '/store'),
          builder: (context) => StorePage()
        );
      case '/supplys':
        return MaterialPageRoute<void>(
          settings: const RouteSettings(name: '/supplys'),
          builder: (context) => SupplysPage()
        );
      case '/settings':
        return MaterialPageRoute<void>(
          settings: const RouteSettings(name: '/settings'),
          builder: (context) =>SettingsPage()
        );
      case '/menu':
        return MaterialPageRoute<void>(
          settings: const RouteSettings(name: '/menu'),
          builder: (context) => MenuPage()
        );
      // case '/menu/add-dish':
      //   return MaterialPageRoute<void>(
      //     settings: const RouteSettings(name: '/menu/add-dish'),
      //     builder: (context) => AddDishPage()
      //   );
      case '/orders':
        return MaterialPageRoute<void>(
          settings: const RouteSettings(name: '/orders'),
          builder: (context) => OrdersPage()
        );
      default:
        return MaterialPageRoute<void>(
            settings: const RouteSettings(name: '/error'),
            builder: (context) => const Center(child: Text("error"))
        );
    }
  }
}