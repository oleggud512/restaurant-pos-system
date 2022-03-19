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
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: "введите описание",
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
        Text(widget.text.isNotEmpty ? widget.text : "описание...", textAlign: TextAlign.start,),
        const Spacer()
      ],
    );
  }
}