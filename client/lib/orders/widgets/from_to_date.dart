import 'package:flutter/material.dart';


class FromToDate extends StatefulWidget {
  FromToDate({Key? key,required this.fromDate,required this.toDate,required this.valueFrom,required this.valueTo}) : super(key: key);

  DateTime fromDate;
  DateTime toDate;
  DateTime valueFrom;
  DateTime valueTo;

  @override
  State<FromToDate> createState() => _FromToDateState();
}

class _FromToDateState extends State<FromToDate> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}