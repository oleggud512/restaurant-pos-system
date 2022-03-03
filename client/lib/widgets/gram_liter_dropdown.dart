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
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        border: OutlineInputBorder()
      ),
      value: value,
      items: const [
        DropdownMenuItem(child: Text("лiтр"), value: "liter"),
        DropdownMenuItem(child: Text("кiлограм"), value: "gram"),
      ],
      onChanged: onChanged
    );
  }
}