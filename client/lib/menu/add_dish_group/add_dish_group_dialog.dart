import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/repo.dart';

class AddDishGroupDialog extends StatelessWidget {
  AddDishGroupDialog({Key? key}) : super(key: key);

  String text = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 250, 
        height: 400,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("добавить группу", style: Theme.of(context).textTheme.headline6),
            TextFormField(
              decoration: InputDecoration(
                labelText: "назва"
              ),
              onChanged: (newVal) {
                text = newVal;
              },
            ),
            ElevatedButton(
              child: Text("add group"),
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