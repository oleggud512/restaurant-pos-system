import 'package:flutter/material.dart';



class InfoFilter extends StatelessWidget {
  InfoFilter({Key? key,required this.onInfo, required this.onFilter}) : super(key: key);

  void Function()? onInfo;
  void Function()? onFilter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.filter_alt_outlined, size: 18),
          splashRadius: 20,
          onPressed: onFilter
        ),
        IconButton(
          icon: const Icon(Icons.info, size: 18),
          splashRadius: 20,
          onPressed: onInfo
        )
      ],
    );
  }
}