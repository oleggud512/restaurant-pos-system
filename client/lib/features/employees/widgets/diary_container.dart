import 'package:client/l10n/app_localizations.g.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../../services/models.dart';

class DiaryContainer extends StatelessWidget {
  const DiaryContainer({Key? key, required this.diary, required this.onDelete, required this.onGone}) : super(key: key);
  
  final void Function()? onDelete;
  final void Function()? onGone;
  final Diary diary;

  @override
  Widget build(BuildContext context) {
    var l = AppLocalizations.of(context)!;
    return Card(
      child: SizedBox(
        height: 25,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: Constants.grey,
                child: Center(child: Text(diary.date.toString().substring(0, 10)))
              )
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: diary.gone ? Constants.grey : Colors.red,
                child: Center(child: Text(diary.dId.toString()))
              )
            ),
            Expanded(
              flex: 10,
              child: Center(child: Text(diary.empName))
            ),
            Expanded(
              flex: 0,
              child: Center(child: Text(' ${l.from} '))
            ),
            Expanded(
              flex: 0,
              child: Center(child: Text(diary.startTime))
            ),
            Expanded(
              flex: 0,
              child: Center(child: Text(' ${l.to} '))
            ),
            Expanded(
              flex: 0,
              child: Center(child: Text(diary.endTime))
            ),
            const Expanded(
              flex: 1,
              child: SizedBox()
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: onGone,
                child: Container(
                  color: Constants.grey,
                  child: Center(child: Text(l.has_gone))
                )
              )
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: onDelete,
                child: Container(
                  color: Constants.grey,
                  child: const Center(child: Icon(Icons.close))
                ),
              )
            )
          ],
        )
      )
    );
  }
}
