import 'package:client/features/menu/domain/entities/prime_cost_data.dart';
import 'package:client/l10n/app_localizations.g.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants.dart';


class PrimeCostTable extends StatefulWidget {
  const PrimeCostTable({Key? key, required this.items}) : super(key: key);

  final List<PrimeCostDataItem> items;

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
        DataColumn(label: Text("${l.price}/${l.measure_short('gram')}(${l.measure_short('liter')})", style: Constants.boldText)),
        DataColumn(label: Text("${l.total} ${l.price}", style: Constants.boldText)),
      ],
      rows: widget.items.map((i) => DataRow(cells: [
        DataCell(Text("#${i.supplierId} | ${i.supplierName}")),
        DataCell(Text(i.groceryName)),
        DataCell(Text(i.count.toString())),
        DataCell(Text(i.price.toString())),
        DataCell(Text(i.total.toString())),
      ])).toList()
    );
  }
}