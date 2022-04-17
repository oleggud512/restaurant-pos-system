import 'package:client/main_states_events.dart';
import 'package:client/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bloc_provider.dart';
import '../l10nn/app_localizations.dart';
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
    AppLocalizations l = AppLocalizations.of(context)!;
    var repo = Provider.of<Repo>(context);
    var bloc = BlocProvider.of<MainBloc>(context);
    return StreamBuilder(
      stream: bloc.outState,
      builder: (context, snapshot) {
        return Scaffold(
          key: key,
          drawer: NavigationDrawer(),
          appBar: AppBar(
            title: Center(child: Text(l.settings)),
            automaticallyImplyLeading: false,
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer()
                );
              }
            )
          ),
          body: ListView(
            children: [
              ListTile(
                title: Text(l.delete_inf_ab_sup),
                onTap: () async {
                  bool agree = await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("All supplys related to deleted suppliers will be deleted. Are you sure?", softWrap: true,),
                        actions: [
                          ElevatedButton(child: Text(l.yes), onPressed: () {
                            Navigator.pop(context, true);
                          }),
                          ElevatedButton(child: Text(l.no), onPressed: () {
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
                    Text(l.dark_theme),
                    Switch(
                      value: (bloc.curBr == Brightness.dark) ? true : false,
                      onChanged: (newVal) {
                        bloc.inEvent.add(MainBrightnessChanged((newVal) ? Brightness.dark : Brightness.light));
                      }, 
                    )
                  ]
                )
              ),
              ListTile(
                title: Row(
                  children: [
                    Text('language: '),
                    DropdownButton<String>(
                      value: bloc.curLang,
                      onChanged: (newVal) {
                        print(newVal);
                        bloc.inEvent.add(MainLanguageChangedEvent(newVal!));
                      },
                      items: [
                        DropdownMenuItem(
                          child: Text(l.ru),
                          value: "ru"
                        ),
                        DropdownMenuItem(
                          child: Text(l.en),
                          value: "en"
                        ),
                        DropdownMenuItem(
                          child: Text(l.uk),
                          value: "uk"
                        )
                      ]
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