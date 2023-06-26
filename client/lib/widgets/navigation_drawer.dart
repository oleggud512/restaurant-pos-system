import 'package:client/l10nn/app_localizations.dart';
import 'package:flutter/material.dart';

import '../employees/employees.dart';
import '../stats/stats_page.dart';



class MyNavigationDrawer extends StatefulWidget {
  const MyNavigationDrawer({Key? key}) : super(key: key);

  @override
  State<MyNavigationDrawer> createState() => _MyNavigationDrawerState();
}

class _MyNavigationDrawerState extends State<MyNavigationDrawer> {
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
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute(builder: (context) => const StatsPage())
                  );
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
                  leading: Image.asset('assets/tr.png', 
                    width: 24, 
                    height: 24, 
                    color: Colors.grey
                  ),
                  title: Text(l.supply('2')),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/supplys');
                  },
                ),
                ListTile(
                  title: Text(l.menu),
                  leading: const Icon(Icons.menu_book_outlined),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/menu');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.people),
                  title: Text(l.employees),
                  onTap: () {
                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(builder: (_) => const Employees())
                    );
                  }
                ),
                ListTile(
                  title: Text(l.orders),
                  leading: const Icon(Icons.shopping_cart),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/orders');
                  }
                ),
              ]
            ),
          ),
          ListTile(
            title: ElevatedButton.icon(
              icon: const Icon(Icons.settings),
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