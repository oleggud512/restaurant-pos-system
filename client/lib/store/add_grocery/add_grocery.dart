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
        child: Column(
          children: [
            const Text("додати інгрідієнт"),
            MyTextField(
              hintText: "введіть назву",
              onChanged: (newVal) {
                widget.groc.grocName = newVal;
              },
            ),
            GramLiterDropdown(
              value: widget.groc.grocMeasure,
              onChanged: (newVal) {
                setState(() {
                  widget.groc.grocMeasure = newVal!;
                });
              }
            ),
            MyTextField(
              hintText: 'введіть кількість',
              onChanged: (newVal) {
                widget.groc.avaCount = int.parse(newVal);
              },
            ),
            TextButton(
              child: Text("додати"),
              onPressed: () {
                widget.repo.addGrocery(widget.groc);
                Navigator.pop(context);
              },
            )
          ]
        )
      )
    );
  }
}