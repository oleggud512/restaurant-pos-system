import 'package:client/utils/extensions/string.dart';
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
            child: Text('NO'.hc),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          FilledButton(
            child: Text('YES'.hc),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ]
    );
  }
}