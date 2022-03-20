import 'package:flutter/material.dart';

import '../../services/models.dart';


class RoleContainer extends StatefulWidget {
  RoleContainer(this.role, {Key? key, this.onTap}) : super(key: key);

  Role role;
  void Function()? onTap;

  @override
  State<RoleContainer> createState() => _RoleContainerState();
}

class _RoleContainerState extends State<RoleContainer> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: InkWell(
        onTap: widget.onTap,
        child: Row(
          children: [
            Container(
              width: 20,
              color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                child: Center(child: Text(widget.role.roleId!.toString())),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                child: Text(widget.role.roleName, overflow: TextOverflow.ellipsis),
              )
            ),
            Container(
              width: 100,
              color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                child: Center(child: Text(widget.role.salaryPerHour.toString(), overflow: TextOverflow.ellipsis)),
              ),
            )
          ]
        )
      )
    );
  }
}