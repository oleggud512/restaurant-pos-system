import 'package:client/l10n/app_localizations.g.dart';
import 'package:flutter/material.dart';


class GenderPickerDropdown extends StatefulWidget {
  const GenderPickerDropdown({Key? key, this.value, this.onChanged}) : super(key: key);

  final void Function(String?)? onChanged;
  final String? value;

  @override
  State<GenderPickerDropdown> createState() => _GenderPickerDropdownState();
}

class _GenderPickerDropdownState extends State<GenderPickerDropdown> {
  @override
  Widget build(BuildContext context) {
    var l = AppLocalizations.of(context)!;
    return DropdownButton<String>(
      isExpanded: true,
      value: widget.value,
      items: [
        DropdownMenuItem(value: 'm', child: Text(l.gen('m'))),
        DropdownMenuItem(value: 'f', child: Text(l.gen('f')))
      ], 
      onChanged: widget.onChanged
    );
  }
}