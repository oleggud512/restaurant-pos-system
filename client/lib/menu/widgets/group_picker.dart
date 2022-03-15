import 'package:flutter/material.dart';

import '../../services/models.dart';

class GroupPicker extends StatefulWidget {
  GroupPicker({
    Key? key, 
    required this.value, 
    required this.groups, 
    required this.onChanged,
    this.enable = true
  }) : super(key: key);  

  void Function(int?)? onChanged;
  int value;
  List<DishGroup> groups;
  bool enable;

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
            child: Text(widget.groups[i].groupName),
            value: widget.groups[i].groupId
          )
        ],
        onChanged: widget.onChanged
      ),
    );
  }
}