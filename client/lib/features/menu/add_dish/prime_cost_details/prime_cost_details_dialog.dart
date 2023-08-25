import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/app_localizations.g.dart';
import '../../../../services/models.dart';
import '../../../../services/repo.dart';
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
        padding: const EdgeInsets.all(10),
        width: 700,
        height: 500,
        child: FutureBuilder(
          future: Provider.of<Repo>(context, listen: false).getPrimeCost(widget.dish),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Map<String, dynamic>? data = snapshot.data as Map<String, dynamic>;
              return Column(
                children: [
                  Center(child: Text(l.prime_cost, style: Theme.of(context).textTheme.titleLarge)),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: (data['consist'] != null) ? 
                        PrimeCostTable(data: data) : const Center(child: Text("grocery list is empty..."))
                    ),
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text("${l.total1}: ", style: const TextStyle(fontWeight: FontWeight.bold))
                      ),
                      Text('${data["total"]}')
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