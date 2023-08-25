import 'package:client/features/home/toggle_drawer_button.dart';
import 'package:client/l10n/app_locale.dart';
import 'package:client/l10n/localizations_context_ext.dart';
import 'package:client/features/settings/settings_events_states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/bloc_provider.dart';
import 'settings_bloc.dart';
import '../../services/repo.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final l = context.ll!;
    final repo = context.read<Repo>();
    final bloc = context.readBloc<AppConfigBloc>();
    return BlocBuilder<AppConfigBloc, SettingsBlocState>(
      builder: (context, state) {
        return Scaffold(
          key: key,
          appBar: AppBar(
            title: Center(child: Text(l.settings)),
            automaticallyImplyLeading: false,
            leading: const ToggleDrawerButton()
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
                        title: const Text("All supplys related to deleted suppliers will be deleted. Are you sure?", softWrap: true,),
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
                      value: (state.brightness == Brightness.dark) ? true : false,
                      onChanged: (newVal) {
                        bloc.add(SettingsBlocBrightnessChangedEvent((newVal) ? Brightness.dark : Brightness.light));
                      }, 
                    )
                  ]
                )
              ),
              ListTile(
                title: Row(
                  children: [
                    Text("${l.language}: "),
                    DropdownButton<Locale>(
                      value: state.locale,
                      onChanged: (newVal) {
                        print(newVal);
                        bloc.add(SettingsBlocLanguageChangedEvent(newVal!));
                      },
                      items: AppLocale.all.map((l) => DropdownMenuItem(
                        value: l,
                        child: Text(l.languageCode),
                      )).toList()
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
