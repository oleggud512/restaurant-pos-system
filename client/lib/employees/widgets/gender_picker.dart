import 'package:client/l10nn/app_localizations.dart';
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
    var l = AppLocalizations.of(context)!;
    return DropdownButton<String>(
      isExpanded: true,
      value: widget.value,
      items: [
        DropdownMenuItem(child: Text(l.gen('m')), value: 'm'),
        DropdownMenuItem(child: Text(l.gen('f')), value: 'f')
      ], 
      onChanged: widget.onChanged
    );
  }
}