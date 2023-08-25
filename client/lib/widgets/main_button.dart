import 'package:flutter/material.dart';


class MainButton extends StatelessWidget {
  const MainButton({Key? key, required void Function()? this.onPressed, 
                              required this.child}) : super(key: key);

  final Function()? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ElevatedButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all<Size>(const Size(100, 70)),
        ),
        onPressed: onPressed, 
        child: child
      )
    );
  }
}