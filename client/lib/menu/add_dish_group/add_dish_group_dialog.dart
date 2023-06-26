import 'package:client/l10nn/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/repo.dart';

class AddDishGroupDialog extends StatelessWidget {
  AddDishGroupDialog({Key? key}) : super(key: key);

  String text = '';

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
              decoration: InputDecoration(
                labelText: l.name
              ),
              onChanged: (newVal) {
                text = newVal;
              },
            ),
            ElevatedButton(
              child: Text(l.add_group),
              onPressed: () async {
                if (text.isNotEmpty) {
                  await Provider.of<Repo>(context, listen: false).addDishGroup(text);
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