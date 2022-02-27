import 'package:flutter/material.dart';

import '../../services/repo.dart';

class AddSupplierDialog extends StatefulWidget {
  const AddSupplierDialog({Key? key, required this.repo}) : super(key: key);

  final Repo repo;

  @override
  State<AddSupplierDialog> createState() => _AddSupplierDialogState();
}

class _AddSupplierDialogState extends State<AddSupplierDialog> {
  TextEditingController nameCont = TextEditingController();
  TextEditingController contactsCont = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 250, 
        height: 300,
        child: Column(
          children: [
            const Text("додати постачальника"),
            TextFormField(
              controller: nameCont,
              decoration: const InputDecoration(
                hintText: "назва"
              ),
            ),
            TextFormField(
              controller: contactsCont,
              decoration: const InputDecoration(
                hintText: "контакти"
              ),
            ),
            ElevatedButton(
              onPressed: () {
                widget.repo.addSupplier(nameCont.text, contactsCont.text);
                Navigator.pop(context);
              }, 
              child: const Text("додати")
            )
          ],
        )
      )
    );
  }
}