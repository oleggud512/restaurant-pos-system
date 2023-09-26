import 'package:client/l10n/app_localizations.g.dart';
import 'package:client/services/entities/employee.dart';
import 'package:client/utils/sizes.dart';
import 'package:flutter/material.dart';

import '../../../utils/dialog_widget.dart';


class SelectEmployeeDialog extends StatefulWidget with DialogWidget<Employee> {
  const SelectEmployeeDialog({Key? key, required this.employees}) : super(key: key);

  final List<Employee> employees;

  @override
  State<SelectEmployeeDialog> createState() => _SelectEmployeeDialogState();
}

class _SelectEmployeeDialogState extends State<SelectEmployeeDialog> {
  late Employee? selectedEmployee;

  @override
  void initState() {
    super.initState();
    if (widget.employees.isNotEmpty) {
      selectedEmployee = widget.employees[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: p336
        ),
        child: Padding(
          padding: const EdgeInsets.all(p16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widget.employees.isNotEmpty
              ? [
                DropdownButton<Employee>(
                  isExpanded: true,
                  value: selectedEmployee,
                  items: [
                    ...widget.employees.map((e) => DropdownMenuItem(
                      value: e,
                      child: Text("${e.empId} || ${e.empFname} ${e.empLname}")
                    ))
                  ],
                  onChanged: (newVal) {
                    setState(() {
                      selectedEmployee = newVal;
                    });
                  }
                ),
                h16gap,
                FilledButton(
                  child: Text(AppLocalizations.of(context)!.has_come),
                  onPressed: () async {
                    Navigator.pop(context, selectedEmployee);
                  }
                ),
              ]
              : [
                const Center(child: Text("employee list is empty"))
              ]
          ),
        ),
      ),
    );
  }
}