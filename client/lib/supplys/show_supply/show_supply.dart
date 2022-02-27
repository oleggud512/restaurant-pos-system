import 'package:flutter/material.dart';

import '../../services/models.dart';

class ShowSupplyDialog extends StatelessWidget {
  ShowSupplyDialog({Key? key, required this.supply}) : super(key: key);

  Supply supply;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 500,
        height: 500,
        child: ListView(
          children: [
            SizedBox(
              child: Center(
                child: Text("supply №" + supply.supplyId.toString(), 
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  )
                )
              )
            ),
            DataTable(
              columns: const [
                DataColumn(label: Text("grocery")),
                DataColumn(label: Text("count"))
              ],
              rows: [
                for (int i = 0; i < supply.groceries.length; i++) DataRow(
                  cells: [
                    DataCell(Text(supply.groceries[i].grocName!)),
                    DataCell(Text(supply.groceries[i].grocCount!.toString()))
                  ]
                )
              ]
            )
          ]
        )
      )
    );
  }
}