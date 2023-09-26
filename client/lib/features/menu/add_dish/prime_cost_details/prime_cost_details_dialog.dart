import 'package:client/features/menu/domain/entities/prime_cost_data.dart';
import 'package:client/services/entities/dish.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/app_localizations.g.dart';
import '../../../../services/repo.dart';
import '../../../../utils/sizes.dart';
import '../widgets/prime_cost_table.dart';

class PrimeCostDetailsDialog extends StatefulWidget {
  const PrimeCostDetailsDialog({Key? key, required this.dish}) : super(key: key);

  // Map<String, dynamic> data;
  final Dish dish;

  @override
  State<PrimeCostDetailsDialog> createState() => _PrimeCostDetailsDialogState();
}

class _PrimeCostDetailsDialogState extends State<PrimeCostDetailsDialog> {

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    var l = AppLocalizations.of(context)!;
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(p24),
        width: 700,
        height: 500,
        child: FutureBuilder<PrimeCostData>(
          future: context.read<Repo>().getPrimeCost(widget.dish.dishGroceries),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              return Column(
                children: [
                  Center(child: Text(l.prime_cost, style: Theme.of(context).textTheme.titleLarge)),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: data.items.isNotEmpty 
                        ? PrimeCostTable(items: data.items) 
                        : const Center(child: Text("grocery list is empty..."))
                    ),
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      Text("${l.total1}: ", style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(data.total.toString())
                    ]
                  )
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          }
        )
      )
    );
  }
}