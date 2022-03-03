import 'package:flutter/material.dart';
import 'package:client/store/widgets/my_text_field.dart';

import '../../services/models.dart';
import '../../services/repo.dart';
import '../../widgets/gram_liter_dropdown.dart';

class AddGroceryDialog extends StatefulWidget {
  AddGroceryDialog({
    Key? key, 
    required this.repo
  }) : super(key: key);

  final MiniGroc groc = MiniGroc.empty();
  final Repo repo;

  @override
  State<AddGroceryDialog> createState() => _AddGroceryDialogState();
}

class _AddGroceryDialogState extends State<AddGroceryDialog> {
  @override
  Widget build(BuildContext context) {
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
              Center(child: Text("додати інгрідієнт", style: Theme.of(context).textTheme.headline6)),
              const SizedBox(height: 10,),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "назва",
                  border: OutlineInputBorder()
                ),
                onChanged: (newVal) {
                  widget.groc.grocName = newVal;
                },
              ),
              const SizedBox(height: 10,),
              GramLiterDropdown(
                value: widget.groc.grocMeasure,
                onChanged: (newVal) {
                  setState(() {
                    widget.groc.grocMeasure = newVal!;
                  });
                }
              ),
              const SizedBox(height: 10,),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "кількість",
                  border: OutlineInputBorder()
                ),
                onChanged: (newVal) {
                  widget.groc.avaCount = int.parse(newVal);
                },
              ),
              const Spacer(),
              ElevatedButton(
                child: Text("додати", style: TextStyle(fontSize: 15)),
                onPressed: () async {
                  await widget.repo.addGrocery(widget.groc);
                  Navigator.pop(context);
                },
              )
            ]
          ),
        )
      )
    );
  }
}