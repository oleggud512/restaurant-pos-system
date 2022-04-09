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
                  title: Text('stats'),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StatsPage()));
                  }
                ),
                ListTile(
                  title: Text('store'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/store');
                  },
                ),
                ListTile(
                  title: Text('supplys'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/supplys');
                  },
                ),
                ListTile(
                  title: Text('supplys'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/menu');
                  },
                ),
                ListTile(
                  title: Text('menu'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/supplys');
                  },
                ),
                ListTile(
                  title: Text('employees'),
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Employees()));
                  }
                ),
                ListTile(
                  title: Text('orders'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/orders');
                  }
                ),
              ]
            ),
          ),
          ListTile(
            title: ElevatedButton(
              child: Text('settings'),
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