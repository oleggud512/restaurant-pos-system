import 'package:flutter/material.dart';

import '../../../services/models.dart';

class GroupPicker extends StatefulWidget {
  const GroupPicker({
    Key? key, 
    required this.value, 
    required this.groups, 
    required this.onChanged,
    this.enable = true
  }) : super(key: key);  

  final void Function(int?)? onChanged;
  final int value;
  final List<DishGroup> groups;
  final bool enable;

  @override
  State<GroupPicker> createState() => _GroupPickerState();
}

class _GroupPickerState extends State<GroupPicker> {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !widget.enable,
      child: DropdownButton<int>(
        isExpanded: true,
        value: widget.value,
        items: [
          for (int i = 0; i < widget.groups.length; i++) DropdownMenuItem(
            value: widget.groups[i].groupId,
            child: Text(widget.groups[i].groupName)
          )
        ],
        onChanged: widget.onChanged
      ),
    );
  }
}