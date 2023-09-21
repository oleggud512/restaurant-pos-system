import 'package:client/features/employees/widgets/role_edit_dialog.dart';
import 'package:client/services/entities/role.dart';
import 'package:client/utils/sizes.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';


class RoleContainer extends StatefulWidget {
  const RoleContainer(this.role, {
    super.key,
    this.onTap,
    this.onEditRole,
    this.onDeleteRole
  });

  final Role role;
  final void Function()? onTap;
  final void Function()? onEditRole;
  final void Function()? onDeleteRole;

  @override
  State<RoleContainer> createState() => _RoleContainerState();
}

class _RoleContainerState extends State<RoleContainer> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: widget.onTap,
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(p4),
            child: Row(
              children: [
                w8gap,
                Text(widget.role.roleId!.toString()),
                const VerticalDivider(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                    child: Text('${widget.role.roleName} - ${widget.role.salaryPerHour} грн./год.',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      )
                    ),
                  )
                ),
                IconButton(
                  onPressed: widget.onEditRole,
                  icon: const Icon(Icons.edit)
                ),
                w8gap,
                IconButton(
                  onPressed: widget.onDeleteRole,
                  icon: const Icon(Icons.delete_forever_outlined)
                ),
                w8gap,
              ]
            ),
          ),
        )
      )
    );
  }
}