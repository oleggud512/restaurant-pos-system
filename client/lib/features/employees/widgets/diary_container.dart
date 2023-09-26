import 'package:client/l10n/app_localizations.g.dart';
import 'package:client/services/entities/diary.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../utils/sizes.dart';

class DiaryContainer extends StatelessWidget {
  const DiaryContainer({Key? key, required this.diary, required this.onDelete, required this.onGone}) : super(key: key);
  
  final void Function()? onDelete;
  final void Function()? onGone;
  final Diary diary;

  @override
  Widget build(BuildContext context) {
    var l = AppLocalizations.of(context)!;

    final textStyle = Theme.of(context).textTheme.bodyLarge;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(p4),
        child: IntrinsicHeight(
          child: Row(
            children: [
              w8gap,
              Text(DateFormat(DateFormat.MONTH_WEEKDAY_DAY).format(diary.date)),
              const VerticalDivider(width: p24),
              Text(diary.dId.toString(),
                style: textStyle,
              ),
              const VerticalDivider(width: p24),
              Text(diary.empName,
                style: textStyle?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const Spacer(),
              Text('${l.from} ${diary.startTime} ${l.to} ${diary.endTime == diary.startTime ? '...' : diary.endTime}',
                style: textStyle?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                )
              ),
              w8gap,
              Tooltip(
                message: 'Mark as gone',
                child: TextButton(
                  onPressed: diary.gone ? null : onGone,
                  child: Text(diary.gone ? 'Has Gone' : 'Working...'),
                ),
              ),
              w8gap,
              IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_forever_outlined)
              ),
              w8gap,
            ],
          ),
        ),
      )
    );
  }
}
