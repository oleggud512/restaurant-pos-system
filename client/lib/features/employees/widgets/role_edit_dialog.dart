import 'package:client/l10n/app_localizations.g.dart';
import 'package:client/l10n/localizations_context_ext.dart';
import 'package:client/services/entities/role.dart';
import 'package:client/utils/dialog_widget.dart';
import 'package:client/utils/extensions/string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class RoleEditDialog extends StatefulWidget with DialogWidget<Role> {
  const RoleEditDialog({
    Key? key,
    this.role,
    this.isEdit = true
  }) : super(key: key);

  final Role? role;
  final bool isEdit;

  @override
  State<RoleEditDialog> createState() => _RoleEditDialogState();
}

class _RoleEditDialogState extends State<RoleEditDialog> {
  late Role role;

  @override
  void initState() {
    role = widget.role?.copyWith() ?? Role();
    super.initState();
  }

  void onRoleNameChanged(String newName) {
    role = role.copyWith(roleName: newName);
  }

  void onRoleSalaryChanged(String newSalary) {
    role = role.copyWith(
        salaryPerHour: double.parse(newSalary.isEmpty ? '0.0' : newSalary)
    );
  }

  @override
  Widget build(BuildContext context) {
    var l = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text('some role...'.hc),
      content: Column(
        children: [
          ListTile(
            title: TextFormField(
              decoration: InputDecoration(
                labelText: l.name
              ),
              initialValue: role.roleName,
              onChanged: onRoleNameChanged
            )
          ),
          const SizedBox(height: 10),
          ListTile(
            title: TextFormField(
              initialValue: role.salaryPerHour.toString(),
              decoration: InputDecoration(
                labelText: l.salary_per_hour
              ),
              onChanged: onRoleSalaryChanged,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
              ]
            )
          )
        ]
      ),
      actions: [
        FilledButton(
          child: Text(context.ll!.add),
          onPressed: () {
            Navigator.pop(context, role);
          }
        )
      ]
    );
  }
}