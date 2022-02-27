import 'package:flutter/material.dart';
import 'package:client/main.dart';
import 'package:client/store/store.dart';
import 'package:client/supplys/supplys.dart';

class MyRouter {
  Route onGenerateRoute(RouteSettings settings) {
    //final GlobalKey<ScaffoldState> key = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute<void>(
          settings: const RouteSettings(name: '/'),
          builder: (context) => HomePage()
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
      default:
        return MaterialPageRoute<void>(
            settings: const RouteSettings(name: '/error'),
            builder: (context) => const Center(child: Text("error"))
        );
    }
  }
}