import 'package:client/services/entities/filter_sort_stats_data.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/logger.dart';
import 'package:client/utils/sizes.dart';
import 'package:flutter/material.dart';



class DishPerPeriodFilterDialog extends StatefulWidget {
  const DishPerPeriodFilterDialog({Key? key, required this.fs}) : super(key: key);

  final FilterSortStatsData fs;

  @override
  State<DishPerPeriodFilterDialog> createState() => _DishPerPeriodFilterDialogState();
}

class _DishPerPeriodFilterDialogState extends State<DishPerPeriodFilterDialog> {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: p400
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            h16gap,
            // ListTile(
            //   title: Center(
            //     child: Row(
            //       // crossAxisAlignment: CrossAxisAlignment.stretch,
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         const Text('date: '),
            //         TextButton(
            //           child: Text(widget.fs.dishFrom.toIso8601String().substring(0, 10)),
            //           onPressed: () async {
            //             var newd = await showDialog(
            //               context: context,
            //               builder: (context) {
            //                 return DatePickerDialog(
            //                   initialDate: widget.fs.dishFrom, 
            //                   firstDate: widget.fs.fromBase, 
            //                   lastDate: widget.fs.toBase
            //                 );
            //               }
            //             );
            //             if (newd != null) {
            //               widget.fs.dishFrom = newd;
            //             }
            //           },
            //         ),
            //         const Text('-'),
            //         TextButton(
            //           child: Text(widget.fs.dishTo.toIso8601String().substring(0, 10)),
            //           onPressed: () async {
            //             var newd = await showDialog(
            //               context: context,
            //               builder: (context) {
            //                 return DatePickerDialog(
            //                   initialDate: widget.fs.dishTo, 
            //                   firstDate: widget.fs.fromBase, 
            //                   lastDate: widget.fs.toBase
            //                 );
            //               }
            //             );
            //             if (newd != null) {
            //               widget.fs.dishFrom = newd;
            //             }
            //           }
            //         )
            //       ],
            //     )
            //   ),
            // ),
            TextButton(
              onPressed: () async {
                final range = await showDialog<DateTimeRange>(
                  context: context,
                  builder: (context) {
                    return DateRangePickerDialog(
                      firstDate: widget.fs.fromBase, 
                      lastDate: widget.fs.toBase,
                      currentDate: DateTime.now()
                    );
                  }
                );
                glogger.i(range);
                if (range == null) return;
                setState(() {
                  widget.fs.dishFrom = range.start;
                  widget.fs.dishTo = range.end;
                });
              },
              child: Text('Date: ${Constants.dateOnlyFormat.format(widget.fs.dishFrom)} - ${Constants.dateOnlyFormat.format(widget.fs.dishTo)}'),
            ),
            ListTile(
              title: FilledButton(
                child: const Text('Apply'),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              )
            ),
            h16gap
          ],
        ),
      )
    );
  }
}