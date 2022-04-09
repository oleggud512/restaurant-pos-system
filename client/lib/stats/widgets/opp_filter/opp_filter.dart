import 'package:client/services/models.dart';
import 'package:flutter/material.dart';


class OrdPerPeriodFilterDialog extends StatefulWidget {
  OrdPerPeriodFilterDialog({Key? key, required this.fs}) : super(key: key);

  FilterSortStats fs;

  @override
  State<OrdPerPeriodFilterDialog> createState() => _OrdPerPeriodFilterDialogState();
}

class _OrdPerPeriodFilterDialogState extends State<OrdPerPeriodFilterDialog> {
  @override
  Widget build(BuildContext context) {
    return  Dialog(
      child: SizedBox(
        width: 200, 
        height: 152,
        child: ListView(
          children: [
            ListTile(
              title: Row(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('date: '),
                  TextButton(
                    child: Text(widget.fs.ordFrom.toIso8601String().substring(0, 10)),
                    onPressed: () async {
                      var newd = await showDialog(
                        context: context,
                        builder: (context) {
                          return DatePickerDialog(
                            initialDate: widget.fs.ordFrom, 
                            firstDate: widget.fs.fromBase, 
                            lastDate: widget.fs.toBase
                          );
                        }
                      );
                      if (newd != null) {
                        widget.fs.ordFrom = newd;
                      }
                    },
                  ),
                  const Text('-'),
                  TextButton(
                    child: Text(widget.fs.dishTo.toIso8601String().substring(0, 10)),
                    onPressed: () async {
                      var newd = await showDialog(
                        context: context,
                        builder: (context) {
                          return DatePickerDialog(
                            initialDate: widget.fs.ordTo, 
                            firstDate: widget.fs.fromBase, 
                            lastDate: widget.fs.toBase
                          );
                        }
                      );
                      if (newd != null) {
                        widget.fs.ordFrom = newd;
                      }
                    }
                  )
                ],
              )
            ),
            ListTile(
              title: DropdownButton<String>(
                isExpanded: true,
                value: widget.fs.group,
                onChanged: (newVal) => setState(() {
                  widget.fs.group = newVal!;
                }),
                items: [
                  DropdownMenuItem(child: Text('hour'), value: 'HOUR'),
                  DropdownMenuItem(child: Text('day'), value: 'DAY'),
                  DropdownMenuItem(child: Text('month'), value: 'MONTH'),
                  DropdownMenuItem(child: Text('year'), value: 'YEAR'),
                ]
              )
            ),
            ListTile(
              title: TextButton(
                child: Text('find'),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              )
            )
          ]
        )
      )
    );
  }
}