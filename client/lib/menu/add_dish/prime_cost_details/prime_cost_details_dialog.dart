import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';

import '../../../l10nn/app_localizations.dart';
import '../../../services/constants.dart';
import '../../../services/models.dart';
import '../../../services/repo.dart';
import '../widgets/prime_cost_table.dart';

class PrimeCostDetailsDialog extends StatefulWidget {
  /*
    на данный момент мы имеем следующее:
      нам нужно переделать в add_dish вызов этого диалога на то чтобы передавать в себестоимость БЛЮДО 
      а не готовые данные
      
   */
  PrimeCostDetailsDialog({Key? key, 
    // this.data = const <String, dynamic>{}, 
    required this.dish}) : super(key: key);

  // Map<String, dynamic> data;
  Dish dish;

  @override
  State<PrimeCostDetailsDialog> createState() => _PrimeCostDetailsDialogState();
}

class _PrimeCostDetailsDialogState extends State<PrimeCostDetailsDialog> {

  // Future dataFut = Future.value({});

  @override
  void initState() {
    super.initState();
    // if (widget.data.isEmpty && widget.dish != null) {
    //   if (widget.dish!.dishGrocs.isNotEmpty) {
    //     widget.data = Provider.of<Repo>(context, listen: false).getPrimeCost(widget.dish!) as Map<String, dynamic>;
    //   } else {
    //     widget.data = <String, dynamic>{'total': 0.0};
    //   }
    // }
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
                  Center(child: Text(l.prime_cost, style: Theme.of(context).textTheme.headline6)),
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
                        child: Text(l.total1 + ": ", style: const TextStyle(fontWeight: FontWeight.bold))
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

    // return Dialog(
    //   child: Container(
    //     padding: const EdgeInsets.all(10),
    //     width: 700,
    //     height: 500,
    //     child: FutureBuilder(
    //       future: Provider.of<Repo>(context, listen: false).getPrimeCost(widget.dish),
    //       builder: (context, snapshot) {
    //           return Column(
    //             children: [
    //               Center(child: Text("Prime Cost", style: Theme.of(context).textTheme.headline6)),
    //               Expanded(
    //                 child: SingleChildScrollView(
    //                   scrollDirection: Axis.vertical,
    //                   child: (widget.data['consist'] != null) ? 
    //                     PrimeCostTable(data: widget.data) : const Center(child: Text("grocery list is empty..."))
    //                 ),
    //               ),
    //               Row(
    //                 children: [
    //                   const Spacer(),
    //                   const Padding(
    //                     padding: EdgeInsets.all(8),
    //                     child: Text("Total: ", style: TextStyle(fontWeight: FontWeight.bold))
    //                   ),
    //                   Text('${widget.data["total"]}')
    //                 ]
    //               )
    //             ],
    //           );
    //       }
    //     )
    //   )
    // );
  }
}