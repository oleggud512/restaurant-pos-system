import 'package:client/l10n/app_localizations.g.dart';
import 'package:flutter/material.dart';

class YesNoDialog extends StatelessWidget {
  const YesNoDialog({Key? key, this.title, required this.onNo, required this.onYes}) : super(key: key);

  final void Function()? onNo;
  final void Function()? onYes;
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      actions: [
        ElevatedButton(
          onPressed: onNo,
          child: Text(AppLocalizations.of(context)!.no),
        ),
        ElevatedButton(
          onPressed: onYes,
          child: Text(AppLocalizations.of(context)!.yes),
        )
      ]
    );
  }
}