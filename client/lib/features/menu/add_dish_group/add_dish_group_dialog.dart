import 'package:client/l10n/app_localizations.g.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/repo.dart';

class AddDishGroupDialog extends StatelessWidget {
  AddDishGroupDialog({Key? key}) : super(key: key);

  final cont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var l = AppLocalizations.of(context)!;
    return Dialog(
      child: Container(
        width: 250, 
        height: 400,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.add_group, style: Theme.of(context).textTheme.titleLarge),
            TextFormField(
              controller: cont,
              decoration: InputDecoration(
                labelText: l.name
              ),
            ),
            ElevatedButton(
              child: Text(l.add_group),
              onPressed: () async {
                if (cont.text.isNotEmpty) {
                  // TODO: move addDishGroup call to bloc away from widget tree...
                  await Provider.of<Repo>(context, listen: false).addDishGroup(cont.text);
                }
                Navigator.pop(context);
              },
            )
          ]
        )
      )
    );
  }
}