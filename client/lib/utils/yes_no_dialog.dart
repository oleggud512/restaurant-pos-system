import 'package:client/l10n/localizations_context_ext.dart';
import 'package:flutter/material.dart';

import 'dialog_widget.dart';

class YesNoDialog extends StatelessWidget with DialogWidget<bool> {

  const YesNoDialog({
    super.key,
    this.message = ''
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            child: Text(context.ll!.no),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          FilledButton(
            child: Text(context.ll!.yes),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ]
    );
  }
}