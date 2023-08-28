import 'package:client/l10n/app_localizations.g.dart';
import 'package:client/services/entities/employee.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/repo.dart';


class DiaryAddDialog extends StatefulWidget {
  const DiaryAddDialog({Key? key, required this.employees}) : super(key: key);

  final List<Employee> employees;

  @override
  State<DiaryAddDialog> createState() => _DiaryAddDialogState();
}

class _DiaryAddDialogState extends State<DiaryAddDialog> {
  late int? value;

  @override
  void initState() {
    super.initState();
    if (widget.employees.isNotEmpty) {
      value = widget.employees[0].empId!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 200,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: widget.employees.isNotEmpty ? [
            ListTile(
              title: DropdownButton<int>(
                isExpanded: true,
                value: value,
                items: [
                  for (int i = 0; i < widget.employees.length; i++) DropdownMenuItem(
                    value: widget.employees[i].empId,
                    child: Text(
                      "${widget.employees[i].empId} || ${widget.employees[i].empFname} ${widget.employees[i].empLname}"
                    )
                  )
                ], 
                onChanged: (newVal) {
                  // print(newVal);
                  setState(() { 
                    value = newVal;
                  });
                }
              ),
            ),
            ListTile(
              title: ElevatedButton(
                child: Text(AppLocalizations.of(context)!.has_come),
                onPressed: () async {
                  await Provider.of<Repo>(context, listen: false).diaryStart(value!);
                  Navigator.pop(context);
                }
              )
            )
          ] : [
            const Center(child: Text("employee list is empty"))
          ]
        ),
      ),
    );
  }
}