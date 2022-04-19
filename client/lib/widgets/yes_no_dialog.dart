import 'package:client/l10nn/app_localizations.dart';
import 'package:flutter/material.dart';

class YesNoDialog extends StatelessWidget {
  YesNoDialog({Key? key, this.title, required this.onNo, required this.onYes}) : super(key: key);

  void Function()? onNo;
  void Function()? onYes;
  Widget? title;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      actions: [
        ElevatedButton(
          child: Text(AppLocalizations.of(context)!.no),
          onPressed: onNo,
        ),
        ElevatedButton(
          child: Text(AppLocalizations.of(context)!.yes),
          onPressed: onYes,
        )
      ]
    );
  }
}