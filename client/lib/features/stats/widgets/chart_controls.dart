import 'package:flutter/material.dart';



class ChartControls extends StatelessWidget {
  const ChartControls({Key? key,required this.onInfoPressed, required this.onFilterPressed}) : super(key: key);

  final void Function()? onInfoPressed;
  final void Function()? onFilterPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.filter_alt_outlined, size: 18),
          splashRadius: 20,
          onPressed: onFilterPressed
        ),
        IconButton(
          icon: const Icon(Icons.info, size: 18),
          splashRadius: 20,
          onPressed: onInfoPressed
        )
      ],
    );
  }
}