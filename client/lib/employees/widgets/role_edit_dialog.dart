import 'package:client/l10nn/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../services/models.dart';
import '../../services/repo.dart';


class RoleEditDialog extends StatefulWidget {
  RoleEditDialog({Key? key, required this.role,this.title, this.actions, this.isEdit = true}) : super(key: key);

  Role role;
  List<Widget>? actions;
  Widget? title;
  bool isEdit;

  @override
  State<RoleEditDialog> createState() => _RoleEditDialogState();
}

class _RoleEditDialogState extends State<RoleEditDialog> {

  @override
  Widget build(BuildContext context) {
    var l = AppLocalizations.of(context)!;
    return AlertDialog(
      title: widget.title,
      content: Column(
        children: [
          ListTile(
            title: TextFormField(
              decoration: InputDecoration(
                labelText: l.name
              ),
              controller: TextEditingController(text: widget.role.roleName),
              onChanged: (newVal) {
                widget.role.roleName = newVal;
              },
            )
          ),
          const SizedBox(height: 10),
          ListTile(
            title: TextFormField(
              decoration: InputDecoration(
                labelText: l.salary_per_hour
              ),
              controller: TextEditingController(text: widget.role.salaryPerHour.toString()),
              onChanged: (newVal) {
                widget.role.salaryPerHour = double.parse(newVal.isEmpty ? '0.0' : newVal);
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
              ]
            )
          )
        ]
      ),
      actions: widget.actions
    );
  }
}