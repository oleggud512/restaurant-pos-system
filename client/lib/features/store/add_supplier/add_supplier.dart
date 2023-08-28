import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.g.dart';
import '../../../services/repo.dart';

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
    var l = AppLocalizations.of(context)!;
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
                child: Text(l.add_supplier, style: Theme.of(context).textTheme.titleLarge)
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: nameCont,
                decoration: InputDecoration(
                  labelText: l.name,
                  border: const OutlineInputBorder()
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: contactsCont,
                decoration: InputDecoration(
                  labelText: l.contacts,
                  border: const OutlineInputBorder()
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () async {
                  await widget.repo.addSupplier(nameCont.text, contactsCont.text);
                  if (mounted) Navigator.pop(context);
                }, 
                child: Text(l.add, style: const TextStyle(
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