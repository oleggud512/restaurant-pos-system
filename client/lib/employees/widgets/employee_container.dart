import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/constants.dart';
import '../../services/models.dart';


class EmployeeContainer extends StatelessWidget {
  EmployeeContainer({Key? key, required this.employee, this.onTap, required this.role}) : super(key: key);

  void Function()? onTap;
  Employee employee;
  Role role;

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
                  color: Provider.of<Constants>(context, listen: false).grey,
                  child: Text(employee.empId.toString(), overflow: TextOverflow.ellipsis)
                )
              ),
              Expanded(
                flex: 16, 
                child: Center(child: Text(employee.empFname + " " + employee.empLname, overflow: TextOverflow.ellipsis))
              ),
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.center,
                  color: Provider.of<Constants>(context, listen: false).grey,
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