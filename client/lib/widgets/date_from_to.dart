import 'package:flutter/material.dart';


class DateFromTo extends StatefulWidget {
  const DateFromTo({Key? key, required this.dateFrom, required this.dateTo}) : super(key: key);

  final DateTime dateFrom;
  final DateTime dateTo;

  @override
  State<DateFromTo> createState() => _DateFromToState();
}

class _DateFromToState extends State<DateFromTo> {

  

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('date: '),
        TextButton(onPressed: () {}, child: const Text(''))
      ],
    );
  }
}