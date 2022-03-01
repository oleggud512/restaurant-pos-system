import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/repo.dart';


class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    var repo = Provider.of<Repo>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("settings")),
      body: ListView(
        children: [
          ListTile(
            title: Text("delete all information about deleted suppliers"),
            onTap: () async {
              bool agree = await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("All supplys related to deleted suppliers will be deleted. Are you sure?", softWrap: true,),
                    actions: [
                      ElevatedButton(child: Text("Yes"), onPressed: () {
                        Navigator.pop(context, true);
                      }),
                      ElevatedButton(child: Text("No"), onPressed: () {
                        Navigator.pop(context, false);
                      }),
                    ]
                  );
                }
              );
              if (agree) {
                repo.delInfoDelSuppliers();
              }
            }
          )
        ]
      )
    );
  }
}