import 'package:client/l10n/app_localizations.g.dart';
import 'package:flutter/material.dart';


class TextEditor extends StatefulWidget {
  const TextEditor({Key? key, required this.text, required this.onChanged, this.isEdit=true}) : super(key: key);

  final String text;
  final bool isEdit;
  final void Function(String)? onChanged;

  @override
  State<TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  late final TextEditingController cont;
  @override
  void initState() { 
    super.initState();
    cont = TextEditingController(text: widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return widget.isEdit ? TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: AppLocalizations.of(context)!.enter_descr,
      ),
      controller: cont,
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