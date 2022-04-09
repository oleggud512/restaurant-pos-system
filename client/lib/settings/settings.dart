import 'package:client/main_states_events.dart';
import 'package:client/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bloc_provider.dart';
import '../main_bloc.dart';
import '../services/repo.dart';


class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var repo = Provider.of<Repo>(context);
    var bloc = BlocProvider.of<MainBloc>(context);
    return StreamBuilder(
      stream: bloc.outState,
      builder: (context, snapshot) {
        return Scaffold(
          key: key,
          drawer: NavigationDrawer(),
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
              ), 
              ListTile(
                title: Row(
                  children: [
                    Text("dark mode: "),
                    Switch(
                      value: (bloc.curBr == Brightness.dark) ? true : false,
                      onChanged: (newVal) {
                        bloc.inEvent.add(MainBrightnessChanged((newVal) ? Brightness.dark : Brightness.light));
                      }, 
                    )
                  ]
                )
              )
            ]
          )
        );
      }
    );
  }
}