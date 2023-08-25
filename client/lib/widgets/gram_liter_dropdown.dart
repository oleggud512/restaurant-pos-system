import 'package:flutter/material.dart';

import '../l10n/app_localizations.g.dart';

class GramLiterDropdown extends StatelessWidget {
  const GramLiterDropdown({
    Key? key, 
    this.value='gram',
    required this.onChanged
  }) : super(key: key);

  final String? value;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    var l = AppLocalizations.of(context)!;
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        border: OutlineInputBorder()
      ),
      value: value,
      items: [
        DropdownMenuItem(value: "liter", child: Text(l.measure('liter'))),
        DropdownMenuItem(value: "gram", child: Text(l.measure('gram'))),
      ],
      onChanged: onChanged
    );
  }
}