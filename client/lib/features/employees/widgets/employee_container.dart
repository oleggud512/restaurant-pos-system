import 'package:client/services/entities/employee.dart';
import 'package:client/services/entities/role.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';


class EmployeeContainer extends StatelessWidget {
  const EmployeeContainer({Key? key, required this.employee, this.onTap, required this.role}) : super(key: key);

  final void Function()? onTap;
  final Employee employee;
  final Role role;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: SizedBox(
        height: 25,
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  color: Constants.grey,
                  child: Text(employee.empId.toString(), overflow: TextOverflow.ellipsis)
                )
              ),
              Expanded(
                flex: 16, 
                child: Center(child: Text("${employee.empFname} ${employee.empLname}", overflow: TextOverflow.ellipsis))
              ),
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.center,
                  color: Constants.grey,
                  child: Text(role.roleName, overflow: TextOverflow.ellipsis)
                )
              )
            ],
          ),
        ),
      )
    );
  }
}