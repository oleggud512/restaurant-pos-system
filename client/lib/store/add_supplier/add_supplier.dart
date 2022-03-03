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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text("Додати постачальника", style: Theme.of(context).textTheme.headline6)
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: nameCont,
                decoration: const InputDecoration(
                  labelText: "ім'я/назва",
                  border: OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: contactsCont,
                decoration: const InputDecoration(
                  labelText: "контакти",
                  border: OutlineInputBorder()
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  await widget.repo.addSupplier(nameCont.text, contactsCont.text);
                  Navigator.pop(context);
                }, 
                child: const Text("додати", style: TextStyle(
                  color: Colors.white,
                  fontSize: 15
                ))
              )
            ],
          ),
        )
      )
    );
  }
}