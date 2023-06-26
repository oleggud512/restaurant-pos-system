import 'package:flutter/material.dart';

import '../../../services/models.dart';


class DishPerPeriodFilterDialog extends StatefulWidget {
  DishPerPeriodFilterDialog({Key? key, required this.fs}) : super(key: key);

  FilterSortStats fs;

  @override
  State<DishPerPeriodFilterDialog> createState() => _DishPerPeriodFilterDialogState();
}

class _DishPerPeriodFilterDialogState extends State<DishPerPeriodFilterDialog> {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 250,
        height: 100,
        child: ListView(
          children: [
            ListTile(
              title: Center(
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('date: '),
                    TextButton(
                      child: Text(widget.fs.dishFrom.toIso8601String().substring(0, 10)),
                      onPressed: () async {
                        var newd = await showDialog(
                          context: context,
                          builder: (context) {
                            return DatePickerDialog(
                              initialDate: widget.fs.dishFrom, 
                              firstDate: widget.fs.fromBase, 
                              lastDate: widget.fs.toBase
                            );
                          }
                        );
                        if (newd != null) {
                          widget.fs.dishFrom = newd;
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
                              initialDate: widget.fs.dishTo, 
                              firstDate: widget.fs.fromBase, 
                              lastDate: widget.fs.toBase
                            );
                          }
                        );
                        if (newd != null) {
                          widget.fs.dishFrom = newd;
                        }
                      }
                    )
                  ],
                )
              ),
            ),
            ListTile(
              title: TextButton(
                child: const Text('find'),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              )
            )
          ],
        ),
      )
    );
  }
}