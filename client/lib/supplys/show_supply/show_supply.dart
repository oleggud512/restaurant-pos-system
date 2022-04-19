import 'package:client/l10nn/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/models.dart';
import '../../services/repo.dart';

class ShowSupplyDialog extends StatelessWidget {
  ShowSupplyDialog({Key? key, required this.supply}) : super(key: key);

  late AppLocalizations l;
  Supply supply;

  @override
  Widget build(BuildContext context) {
    l = AppLocalizations.of(context)!;
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 500,
        height: 500,
        child: Column(
          children: [
            SizedBox(
              child: Center(
                child: Text(l.supply(1) + " №" + supply.supplyId.toString(), 
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  )
                )
              )
            ),
            DataTable(
              columns: [
                DataColumn(label: Text(l.grocery(1))),
                DataColumn(label: Text(l.count))
              ],
              rows: [
                for (int i = 0; i < supply.groceries.length; i++) DataRow(
                  cells: [
                    DataCell(Text(supply.groceries[i].grocName!)),
                    DataCell(Text(supply.groceries[i].grocCount!.toString()))
                  ]
                )
              ]
            ), 
            const Spacer(),
            Row(
              children: [
                ElevatedButton(
                  onPressed:() async {
                    await Provider.of<Repo>(context, listen: false).deleteSupply(supply.supplyId!);
                    Navigator.pop(context, true);
                  },
                  child: const Icon(Icons.delete)
                ),
                const Spacer()
              ],
            )
          ]
        )
      )
    );
  }
}