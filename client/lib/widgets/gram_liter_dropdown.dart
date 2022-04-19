import 'package:flutter/material.dart';

import '../l10nn/app_localizations.dart';

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
    var l = AppLocalizations.of(context)!;
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        border: OutlineInputBorder()
      ),
      value: value,
      items: [
        DropdownMenuItem(child: Text(l.measure('liter')), value: "liter"),
        DropdownMenuItem(child: Text(l.measure('gram')), value: "gram"),
      ],
      onChanged: onChanged
    );
  }
}