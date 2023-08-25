import 'package:flutter/material.dart';


class LabelIconButton extends StatelessWidget {
  const LabelIconButton({Key? key, required this.onTap,  required this.icon, required this.text}) : super(key: key);
  
  final void Function()? onTap;
  final Icon icon;
  final Text text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [ icon, text ],
        ))
      )
    );
  }
}