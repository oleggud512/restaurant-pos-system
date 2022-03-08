import 'package:flutter/material.dart';

class DishDetalsPage extends StatefulWidget {
  DishDetalsPage({Key? key}) : super(key: key);

  @override
  State<DishDetalsPage> createState() => _DishDetalsPageState();
}

class _DishDetalsPageState extends State<DishDetalsPage> {
  bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(color: Colors.blue) // photo
              ),
              Expanded(
                flex: 2,
                child: Container(color: Colors.green) // table
              )
            ]
          )
        )
      ]
    );
  }
}