import 'package:client/employees/widgets/gender_picker.dart';
import 'package:flutter/material.dart';

import '../../services/models.dart';


class EmployeeEditDialog extends StatefulWidget {
  EmployeeEditDialog({Key? key, this.employee, required this.roles, this.actions = const <Widget>[]}) : super(key: key);

  Employee? employee;
  List<Role> roles;
  List<Widget> actions;

  @override
  State<EmployeeEditDialog> createState() => _EmployeeEditDialogState();
}

class _EmployeeEditDialogState extends State<EmployeeEditDialog> {

  @override
  void initState() {
    super.initState();
    widget.employee ??= Employee.init();
  }

  @override
  Widget build(BuildContext context) {
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
                        controller: TextEditingController(text: widget.employee!.empFname),
                        decoration: InputDecoration(
                          labelText: "first name"
                        ),
                        onChanged: (newVal) {
                          widget.employee!.empFname = newVal;
                        },
                      ),
                    ),
                    ListTile(
                      title: TextFormField(
                        controller: TextEditingController(text: widget.employee!.empLname),
                        decoration: InputDecoration(
                          labelText: "last name"
                        ),
                        onChanged: (newVal) {
                          widget.employee!.empLname = newVal;
                        },
                      ),
                    ),
                    ListTile(
                      title: InkWell(
                        child: Center(child: Text(widget.employee!.birthday.toString().substring(0, 10))),
                        onTap: () async {
                          var date = await showDatePicker(
                            context: context, 
                            initialDate: widget.employee!.birthday,
                            firstDate: DateTime.parse('1960-01-01'),
                            lastDate: DateTime.now()
                          );
                          if (date != null) {
                            setState(() {
                              widget.employee!.birthday = date;
                            });
                          }
                        }
                      )
                    ),
                    ListTile(
                      title: GenderPickerDropdown(
                        value: widget.employee!.gender,
                        onChanged: (newVal) {
                          setState(() {
                            widget.employee!.gender = newVal!;
                          });
                        },
                      )
                    ),
                    ListTile(
                      title: DropdownButton<int>(
                        isExpanded: true,
                        value: widget.employee!.roleId,
                        items: [
                          DropdownMenuItem(child: Text("none"), value: 0),
                          for (int i = 0; i < widget.roles.length; i++) DropdownMenuItem(
                            child: Text(widget.roles[i].roleName),
                            value: widget.roles[i].roleId
                          )
                        ],
                        onChanged: (newVal) {
                          setState(() {
                            widget.employee!.roleId = newVal!;
                          });
                        }
                      ) 
                    ),
                    ListTile(
                      title: TextFormField(
                        decoration: InputDecoration(
                          labelText: "hours per month"
                        ),
                        controller: TextEditingController(text: widget.employee!.hoursPerMonth.toString()),
                        onChanged: (newVal) {
                          widget.employee!.hoursPerMonth = int.parse(newVal.isEmpty ? '0' : newVal);
                        },
                      )
                    ),
                    ListTile(
                      leading: Checkbox(
                        value: widget.employee!.isWaiter,
                        onChanged: (newVal) {
                          setState(() {
                            widget.employee!.isWaiter = newVal!;
                          });
                        }
                      ),
                      title: Text("официант")
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