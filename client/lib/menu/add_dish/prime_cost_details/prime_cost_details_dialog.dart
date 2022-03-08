import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/constants.dart';

class PrimeCostDetailsDialog extends StatefulWidget {
  PrimeCostDetailsDialog({Key? key, required this.data}) : super(key: key);

  Map<String, dynamic> data;

  @override
  State<PrimeCostDetailsDialog> createState() => _PrimeCostDetailsDialogState();
}

class _PrimeCostDetailsDialogState extends State<PrimeCostDetailsDialog> {
  @override
  Widget build(BuildContext context) {

    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 700,
        height: 500,
        child: Column(
          children: [
            Center(child: Text("Prime Cost", style: Theme.of(context).textTheme.headline6)),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: (widget.data['consist'] != null) ? DataTable(
                  columns: [
                    DataColumn(label: Text("supplier", style: Provider.of<Constants>(context).boldText)),
                    DataColumn(label: Text("groc name", style: Provider.of<Constants>(context).boldText)),
                    DataColumn(label: Text("groc count", style: Provider.of<Constants>(context).boldText)),
                    DataColumn(label: Text("price/kg", style: Provider.of<Constants>(context).boldText)),
                    DataColumn(label: Text("total price", style: Provider.of<Constants>(context).boldText)),
                  ],
                  rows: [
                    for (dynamic consist in widget.data['consist']) DataRow(cells: [
                      DataCell(Text("# " + consist['supplier_id'].toString() + " " + consist['supplier_name'])),
                      DataCell(Text(consist['groc_name'])),
                      DataCell(Text(consist['groc_count'].toString())),
                      DataCell(Text(consist['min_price'].toString())),
                      DataCell(Text(consist['groc_total'].toString())),
                    ])
                  ]
                ) : const Center(child: Text("grocery list is empty..."))
              ),
            ),
            Row(
              children: [
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("Total: ", style: TextStyle(fontWeight: FontWeight.bold))
                ),
                Text('${widget.data["total"]}')
              ]
            )
          ],
        )
      )
    );
  }
}