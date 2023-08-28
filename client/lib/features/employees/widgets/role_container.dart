import 'package:client/services/entities/role.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';


class RoleContainer extends StatefulWidget {
  const RoleContainer(this.role, {Key? key, this.onTap}) : super(key: key);

  final Role role;
  final void Function()? onTap;

  @override
  State<RoleContainer> createState() => _RoleContainerState();
}

class _RoleContainerState extends State<RoleContainer> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: SizedBox(
        height: 25,
        child: InkWell(
          onTap: widget.onTap,
          child: Row(
            children: [
              Container(
                width: 20,
                color: Constants.grey,
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
                color: Constants.grey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                  child: Center(child: Text(widget.role.salaryPerHour.toString(), overflow: TextOverflow.ellipsis)),
                ),
              )
            ]
          )
        ),
      )
    );
  }
}