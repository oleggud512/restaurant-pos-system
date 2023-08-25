import 'package:client/l10n/app_localizations.g.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants.dart';


class PrimeCostTable extends StatefulWidget {
  const PrimeCostTable({Key? key, required this.data}) : super(key: key);

  final Map<String, dynamic> data;

  @override
  State<PrimeCostTable> createState() => _PrimeCostTableState();
}

class _PrimeCostTableState extends State<PrimeCostTable> {
  @override
  Widget build(BuildContext context) {
    var l = AppLocalizations.of(context)!;
    return DataTable(
      columns: [
        DataColumn(label: Text(l.supplier('1'), style: Constants.boldText)),
        DataColumn(label: Text(l.grocery(1), style: Constants.boldText)),
        DataColumn(label: Text(l.count, style: Constants.boldText)),
        DataColumn(label: Text("${l.price}/${l.measure_short('gram')}", style: Constants.boldText)),
        DataColumn(label: Text("${l.total} ${l.price}", style: Constants.boldText)),
      ],
      rows: [
        for (dynamic consist in widget.data['consist']) DataRow(cells: [
          DataCell(Text("# ${consist['supplier_id']} ${consist['supplier_name']}")),
          DataCell(Text(consist['groc_name'])),
          DataCell(Text(consist['groc_count'].toString())),
          DataCell(Text(consist['min_price'].toString())),
          DataCell(Text(consist['groc_total'].toString())),
        ])
      ]
    );
  }
}