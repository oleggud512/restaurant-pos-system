import 'package:flutter/material.dart';


class GenderPickerDropdown extends StatefulWidget {
  GenderPickerDropdown({Key? key, this.value, this.onChanged}) : super(key: key);

  void Function(String?)? onChanged;
  String? value;

  @override
  State<GenderPickerDropdown> createState() => _GenderPickerDropdownState();
}

class _GenderPickerDropdownState extends State<GenderPickerDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      isExpanded: true,
      value: widget.value,
      items: [
        DropdownMenuItem(child: Text("male"), value: 'm'),
        DropdownMenuItem(child: Text("female"), value: 'f')
      ], 
      onChanged: widget.onChanged
    );
  }
}