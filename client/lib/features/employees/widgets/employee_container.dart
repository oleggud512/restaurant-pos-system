import 'package:client/services/entities/employee.dart';
import 'package:client/services/entities/role.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../../utils/sizes.dart';


class EmployeeContainer extends StatelessWidget {
  const EmployeeContainer({Key? key, required this.employee, this.onTap, required this.role}) : super(key: key);

  final void Function()? onTap;
  final Employee employee;
  final Role role;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge;
    final emphasisTextStyle = textStyle?.copyWith(
      color: Theme.of(context).colorScheme.primary
    );
    // TODO: (2) сделать полноценный раутинг для всего в employees
    return Card(
      elevation: 3.0,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(p8),
          child: IntrinsicHeight(
            child: Row(
              children: [
                w4gap,
                Text(employee.empId.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: textStyle,
                ),
                const VerticalDivider(width: p24),
                Text("${employee.empFname} ${employee.empLname}",
                  overflow: TextOverflow.ellipsis,
                  style: emphasisTextStyle
                ),
                const Spacer(),
                const VerticalDivider(width: p24),
                Text(role.roleName,
                  overflow: TextOverflow.ellipsis,
                  style: emphasisTextStyle
                ),
                w4gap,
              ],
            ),
          ),
        ),
      )
    );
  }
}