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
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.bar_chart_outlined),
                  title: Text('stats'),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StatsPage()));
                  }
                ),
                ListTile(
                  leading: const Icon(Icons.store_mall_directory),
                  title: Text('store'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/store');
                  },
                ),
                ListTile(
                  leading: Image.asset('assets/tr.png', width: 24, height: 24, color: Colors.grey),
                  title: Text('supplys'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/supplys');
                  },
                ),
                ListTile(
                  title: Text('menu'),
                  leading: Icon(Icons.menu_book_outlined),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/menu');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.people),
                  title: Text('employees'),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Employees()));
                  }
                ),
                ListTile(
                  title: Text('orders'),
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
              label: Text('settings'),
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