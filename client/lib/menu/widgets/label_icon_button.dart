import 'package:flutter/material.dart';


class LabelIconButton extends StatelessWidget {
  LabelIconButton({Key? key, required this.onTap,  required this.icon, required this.text}) : super(key: key);
  
  void Function()? onTap;
  Icon icon;
  Text text;

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