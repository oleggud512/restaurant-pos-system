import 'package:client/l10nn/app_localizations.dart';
import 'package:flutter/material.dart';


class TextEditor extends StatefulWidget {
  TextEditor({Key? key, required this.text, required this.onChanged, this.isEdit=true}) : super(key: key);

  String text;
  bool isEdit;
  void Function(String)? onChanged;

  @override
  State<TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  @override
  Widget build(BuildContext context) {
    return widget.isEdit ? TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: AppLocalizations.of(context)!.enter_descr,
      ),
      controller: TextEditingController(text: widget.text),
      textAlignVertical: TextAlignVertical.top,
      maxLines: null,
      minLines: null,
      expands: true,
      onChanged: widget.onChanged,
    ) : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.text.isNotEmpty ? widget.text : AppLocalizations.of(context)!.no_descr, textAlign: TextAlign.start),
        const Spacer()
      ],
    );
  }
}