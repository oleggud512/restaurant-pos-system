import 'package:client/l10n/app_localizations.g.dart';
import 'package:client/services/entities/grocery/mini_grocery.dart';
import 'package:flutter/material.dart';

import '../../../services/repo.dart';
import '../../../widgets/gram_liter_dropdown.dart';


class AddGroceryDialog extends StatefulWidget {
  const AddGroceryDialog({
    Key? key, 
    required this.repo
  }) : super(key: key);

  final Repo repo;

  @override
  State<AddGroceryDialog> createState() => _AddGroceryDialogState();
}

class _AddGroceryDialogState extends State<AddGroceryDialog> {

  MiniGrocery groc = const MiniGrocery(); // TODO: (7) create bloc for add grocery dialog 

  @override
  Widget build(BuildContext context) {
    var l = AppLocalizations.of(context)!;
    return Dialog(
      child: Container(
        width: 300,
        height: 400,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10,),
              Center(child: Text("${l.add} ${l.grocery(1).toLowerCase()}", style: Theme.of(context).textTheme.titleLarge)),
              const SizedBox(height: 10,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: l.name,
                  border: const OutlineInputBorder()
                ),
                onChanged: (newVal) {
                  groc = groc.copyWith(grocName: newVal);
                },
              ),
              const SizedBox(height: 10,),
              GramLiterDropdown(
                value: groc.grocMeasure,
                onChanged: (newVal) {
                  setState(() {
                    groc = groc.copyWith(grocMeasure: newVal);
                  });
                }
              ),
              const SizedBox(height: 10,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: l.count,
                  border: const OutlineInputBorder()
                ),
                onChanged: (newVal) {
                  groc = groc.copyWith(avaCount: int.parse(newVal));
                },
              ),
              const Spacer(),
              FilledButton(
                child: Text(l.add, style: const TextStyle(fontSize: 15)),
                onPressed: () async {
                  await widget.repo.addGrocery(groc);
                  if (mounted) Navigator.pop(context);
                },
              )
            ]
          ),
        )
      )
    );
  }
}