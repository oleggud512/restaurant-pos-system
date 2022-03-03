import 'package:flutter/material.dart';


class MyTextField extends StatelessWidget {
  MyTextField({
    Key? key, 
    this.onChanged,
    this.controller,
    this.hintText='',
  }) : super(key: key);

  String hintText;
  void Function(String)? onChanged;
  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 60,
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 3.0
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10.0))
        ),
        child: TextFormField(
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'введіть назву інгредієнту',
          ),
          onChanged: onChanged,
          controller: controller,
          style: const TextStyle(
            fontSize: 20,
          )
        )
      ),
    );
  }
}