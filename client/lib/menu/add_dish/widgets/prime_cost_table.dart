import 'package:client/l10nn/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/constants.dart';


class PrimeCostTable extends StatefulWidget {
  PrimeCostTable({Key? key, required this.data}) : super(key: key);

  Map<String, dynamic> data;

  @override
  State<PrimeCostTable> createState() => _PrimeCostTableState();
}

class _PrimeCostTableState extends State<PrimeCostTable> {
  @override
  Widget build(BuildContext context) {
    var l = AppLocalizations.of(context)!;
    return DataTable(
      columns: [
        DataColumn(label: Text(l.supplier(1), style: Provider.of<Constants>(context).boldText)),
        DataColumn(label: Text(l.grocery(1), style: Provider.of<Constants>(context).boldText)),
        DataColumn(label: Text(l.count, style: Provider.of<Constants>(context).boldText)),
        DataColumn(label: Text(l.price + "/" + l.measure_short('gram'), style: Provider.of<Constants>(context).boldText)),
        DataColumn(label: Text(l.total + " " + l.price, style: Provider.of<Constants>(context).boldText)),
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
    );
  }
}