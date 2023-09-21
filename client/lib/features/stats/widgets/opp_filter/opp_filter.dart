import 'package:client/l10n/localizations_context_ext.dart';
import 'package:client/services/entities/filter_sort_stats_data.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/logger.dart';
import 'package:client/utils/sizes.dart';
import 'package:flutter/material.dart';


class OrdPerPeriodFilterDialog extends StatefulWidget {
  const OrdPerPeriodFilterDialog({Key? key, required this.fs}) : super(key: key);

  final FilterSortStatsData fs;

  @override
  State<OrdPerPeriodFilterDialog> createState() => _OrdPerPeriodFilterDialogState();
}

class _OrdPerPeriodFilterDialogState extends State<OrdPerPeriodFilterDialog> {
  @override
  Widget build(BuildContext context) {
    return  Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: p400
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            h16gap,
            // ListTile(
            //   title: Row(
            //     // crossAxisAlignment: CrossAxisAlignment.stretch,
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       const Text('date: '),
            //       TextButton(
            //         child: Text(widget.fs.ordFrom.toIso8601String().substring(0, 10)),
            //         onPressed: () async {
            //           var newd = await showDialog(
            //             context: context,
            //             builder: (context) {
            //               return DatePickerDialog(
            //                 initialDate: widget.fs.ordFrom, 
            //                 firstDate: widget.fs.fromBase, 
            //                 lastDate: widget.fs.toBase
            //               );
            //             }
            //           );
            //           if (newd != null) {
            //             widget.fs.ordFrom = newd;
            //           }
            //         },
            //       ),
            //       const Text('-'),
            //       TextButton(
            //         child: Text(widget.fs.dishTo.toIso8601String().substring(0, 10)),
            //         onPressed: () async {
            //           var newd = await showDialog(
            //             context: context,
            //             builder: (context) {
            //               return DatePickerDialog(
            //                 initialDate: widget.fs.ordTo, 
            //                 firstDate: widget.fs.fromBase, 
            //                 lastDate: widget.fs.toBase
            //               );
            //             }
            //           );
            //           if (newd != null) {
            //             widget.fs.ordFrom = newd;
            //           }
            //         }
            //       )
            //     ],
            //   )
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
                  widget.fs.ordFrom = range.start;
                  widget.fs.ordTo = range.end;
                });
              },
              child: Text('Date: ${Constants.dateOnlyFormat.format(widget.fs.ordFrom)} - ${Constants.dateOnlyFormat.format(widget.fs.ordTo)}'),
            ),
            ListTile(
              title: DropdownButtonFormField<String>(
                isExpanded: true,
                value: widget.fs.group,
                onChanged: (newVal) => setState(() {
                  widget.fs.group = newVal!;
                }),
                items: const [
                  DropdownMenuItem(value: 'HOUR', child: Text('hour')),
                  DropdownMenuItem(value: 'DAY', child: Text('day')),
                  DropdownMenuItem(value: 'MONTH', child: Text('month')),
                  DropdownMenuItem(value: 'YEAR', child: Text('year')),
                ]
              )
            ),
            ListTile(
              title: FilledButton(
                child: const Text('Apply'),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              )
            ),
            h16gap,
          ]
        ),
      )
    );
  }
}