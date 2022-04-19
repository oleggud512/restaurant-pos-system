import 'package:client/l10nn/app_localizations.dart';
import 'package:flutter/material.dart';

import '../employees/employees.dart';
import '../stats./stats_page.dart';



class NavigationDrawer extends StatefulWidget {
  NavigationDrawer({Key? key}) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context)!;
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.bar_chart_outlined),
                  title: Text(l.stats),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StatsPage()));
                  }
                ),
                ListTile(
                  leading: const Icon(Icons.store_mall_directory),
                  title: Text(l.store),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/store');
                  },
                ),
                ListTile(
                  leading: Image.asset('assets/tr.png', width: 24, height: 24, color: Colors.grey),
                  title: Text(l.supply(2)),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/supplys');
                  },
                ),
                ListTile(
                  title: Text(l.menu),
                  leading: Icon(Icons.menu_book_outlined),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/menu');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.people),
                  title: Text(l.employees),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Employees()));
                  }
                ),
                ListTile(
                  title: Text(l.orders),
                  leading: Icon(Icons.shopping_cart),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/orders');
                  }
                ),
              ]
            ),
          ),
          ListTile(
            title: ElevatedButton.icon(
              icon: Icon(Icons.settings),
              label: Text(l.settings),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/settings');
              },
            )
          )
        ],
      )
    );
  }
}