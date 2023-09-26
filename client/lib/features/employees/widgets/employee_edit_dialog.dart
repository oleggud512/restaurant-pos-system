import 'package:client/features/employees/widgets/gender_picker.dart';
import 'package:client/l10n/localizations_context_ext.dart';
import 'package:client/services/entities/employee.dart';
import 'package:client/services/entities/role.dart';
import 'package:client/utils/dialog_widget.dart';
import 'package:flutter/material.dart';



class EmployeeEditDialog extends StatefulWidget with DialogWidget<Employee> {
  const EmployeeEditDialog({
    Key? key, this.employee,
    required this.roles,
  }) : super(key: key);

  final Employee? employee;
  final List<Role> roles;

  @override
  State<EmployeeEditDialog> createState() => _EmployeeEditDialogState();
}

class _EmployeeEditDialogState extends State<EmployeeEditDialog> {
  late Employee emp;
  @override
  void initState() {
    super.initState();
    emp = widget.employee?.copyWith() ?? Employee();
  }

  onFirstNameChanged(String newFirstName) {
    emp = emp.copyWith(empFname: newFirstName);
  }

  onLastNameChanged(String newLastName) {
    emp = emp.copyWith(empLname: newLastName);
  }

  selectBirthday() async {
    var date = await showDatePicker(
        context: context,
        initialDate: emp.birthday,
        firstDate: DateTime.parse('1960-01-01'),
        lastDate: DateTime.now()
    );
    if (date == null) return;
    setState(() {
      emp = emp.copyWith(birthday: date);
    });
  }

  onGenderChanged(String? newGender) {
    setState(() {
      emp = emp.copyWith(gender: newGender);
    });
  }

  onRoleChanged(int? newRole) {
    setState(() {
      emp = emp.copyWith(roleId: newRole);
    });
  }

  onHoursPerMonthChanged(String newHoursPerMonth) {
    emp = emp.copyWith(
        hoursPerMonth: int.parse(newHoursPerMonth.isEmpty
            ? '0'
            : newHoursPerMonth)
    );
  }

  onIsWaiterChanged(bool? newIsWaiter) {
    setState(() {
      emp = emp.copyWith(isWaiter: newIsWaiter);
    });
  }

  @override
  Widget build(BuildContext context) {
    var ll = context.ll!;
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
                        initialValue: emp.empFname,
                        decoration: InputDecoration(
                          labelText: ll.namee
                        ),
                        onChanged: onFirstNameChanged,
                      ),
                    ),
                    ListTile(
                      title: TextFormField(
                        initialValue: emp.empLname,
                        decoration: InputDecoration(
                          labelText: ll.surname
                        ),
                        onChanged: onLastNameChanged,
                      ),
                    ),
                    ListTile(
                      title: TextButton(
                        onPressed: selectBirthday,
                        child: Text(emp.birthday.toString().substring(0, 10))
                      )
                    ),
                    ListTile(
                      title: GenderPickerDropdown(
                        value: emp.gender,
                        onChanged: onGenderChanged,
                      )
                    ),
                    ListTile(
                      title: DropdownButton<int>(
                        isExpanded: true,
                        value: emp.roleId,
                        items: [
                          DropdownMenuItem(
                            value: 0, 
                            child: Text(ll.no_role_selected_placeholder)
                          ),
                          ...widget.roles.map((r) => DropdownMenuItem(
                            value: r.roleId,
                            child: Text(r.roleName)
                          )).toList()
                        ],
                        onChanged: onRoleChanged
                      ) 
                    ),
                    ListTile(
                      title: TextFormField(
                        decoration: InputDecoration(
                          labelText: ll.hours_per_month
                        ),
                        initialValue: emp.hoursPerMonth.toString(),
                        onChanged: onHoursPerMonthChanged,
                      )
                    ),
                    ListTile(
                      leading: Checkbox(
                        value: emp.isWaiter,
                        onChanged: onIsWaiterChanged
                      ),
                      title: Text(ll.waiter)
                    )
                  ]
                ),
              ),
              Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(ll.cancel),
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.pop(context, emp);
                    },
                    child: Text(ll.submit)
                  )
                ]
              )
            ],
          )
        ),
      )
    );
  }
}