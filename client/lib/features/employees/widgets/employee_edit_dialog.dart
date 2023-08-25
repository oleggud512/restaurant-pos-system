import 'package:client/features/employees/widgets/gender_picker.dart';
import 'package:client/l10n/app_localizations.g.dart';
import 'package:flutter/material.dart';

import '../../../services/models.dart';


class EmployeeEditDialog extends StatefulWidget {
  const EmployeeEditDialog({Key? key, this.employee, required this.roles, this.actions = const <Widget>[]}) : super(key: key);

  final Employee? employee;
  final List<Role> roles;
  final List<Widget> actions;

  @override
  State<EmployeeEditDialog> createState() => _EmployeeEditDialogState();
}

class _EmployeeEditDialogState extends State<EmployeeEditDialog> {
  late Employee emp;
  @override
  void initState() {
    super.initState();
    emp = widget.employee ?? Employee.init();
  }

  @override
  Widget build(BuildContext context) {
    var l = AppLocalizations.of(context)!;
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 200,
          height: 450,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children : [
                    ListTile(
                      title: TextFormField(
                        controller: TextEditingController(text: emp.empFname),
                        decoration: InputDecoration(
                          labelText: l.namee
                        ),
                        onChanged: (newVal) {
                          emp.empFname = newVal;
                        },
                      ),
                    ),
                    ListTile(
                      title: TextFormField(
                        controller: TextEditingController(text: emp.empLname),
                        decoration: InputDecoration(
                          labelText: l.surname
                        ),
                        onChanged: (newVal) {
                          emp.empLname = newVal;
                        },
                      ),
                    ),
                    ListTile(
                      title: InkWell(
                        child: Center(child: Text(emp.birthday.toString().substring(0, 10))),
                        onTap: () async {
                          var date = await showDatePicker(
                            context: context, 
                            initialDate: emp.birthday,
                            firstDate: DateTime.parse('1960-01-01'),
                            lastDate: DateTime.now()
                          );
                          if (date != null) {
                            setState(() {
                              emp.birthday = date;
                            });
                          }
                        }
                      )
                    ),
                    ListTile(
                      title: GenderPickerDropdown(
                        value: emp.gender,
                        onChanged: (newVal) {
                          setState(() {
                            emp.gender = newVal!;
                          });
                        },
                      )
                    ),
                    ListTile(
                      title: DropdownButton<int>(
                        isExpanded: true,
                        value: emp.roleId,
                        items: [
                          const DropdownMenuItem(value: 0, child: Text("none")),
                          for (int i = 0; i < widget.roles.length; i++) DropdownMenuItem(
                            value: widget.roles[i].roleId,
                            child: Text(widget.roles[i].roleName)
                          )
                        ],
                        onChanged: (newVal) {
                          setState(() {
                            emp.roleId = newVal!;
                          });
                        }
                      ) 
                    ),
                    ListTile(
                      title: TextFormField(
                        decoration: InputDecoration(
                          labelText: l.hours_per_month
                        ),
                        controller: TextEditingController(text: emp.hoursPerMonth.toString()),
                        onChanged: (newVal) {
                          emp.hoursPerMonth = int.parse(newVal.isEmpty ? '0' : newVal);
                        },
                      )
                    ),
                    ListTile(
                      leading: Checkbox(
                        value: emp.isWaiter,
                        onChanged: (newVal) {
                          setState(() {
                            emp.isWaiter = newVal!;
                          });
                        }
                      ),
                      title: Text(l.waiter)
                    )
                  ]
                ),
              ),
              Row(
                children: [
                  const Spacer(),
                  ...widget.actions
                ]
              )
            ],
          )
        ),
      )
    );
  }
}