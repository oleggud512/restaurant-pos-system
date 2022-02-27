import 'package:flutter/material.dart';

class GramLiterDropdown extends StatelessWidget {
  GramLiterDropdown({
    Key? key, 
    this.value='gram',
    required this.onChanged
  }) : super(key: key);

  String? value;
  void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      items: const [
        DropdownMenuItem(child: Text("литр"), value: "liter"),
        DropdownMenuItem(child: Text("грам"), value: "gram"),
      ],
      onChanged: onChanged
    );
  }
}