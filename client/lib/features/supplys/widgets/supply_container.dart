import 'package:client/l10n/app_localizations.g.dart';
import 'package:flutter/material.dart';
import '../../../services/models.dart' as m;
import '../add_supply/add_supply.dart';
import '../supplys_bloc.dart';
import '../supplys_states_events.dart';


class SupplyContainer extends StatelessWidget {
  const SupplyContainer({Key? key, required this.supply, required this.view, required this.onTap}) : super(key: key);

  final m.Supply supply;
  final m.DataView view;
  final void Function()? onTap;

  final TextStyle style = const TextStyle(
    fontWeight: FontWeight.bold
  );

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Card(
      elevation: 3.0,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          width: 300, 
          height: (view == m.DataView.grid) ? 100 : 80,
          child: Column(
            children: [
              Row(
                children: [
                  Text("${l.number}: "),
                  Text(supply.supplyId.toString(), style: style)
                ],
              ),
              Row(
                children: [
                  Text("${l.supplier('1')}: "),
                  Flexible(
                    child: Text("#${supply.supplierId} ${supply.supplierName}", 
                      style: style, 
                      overflow: TextOverflow.ellipsis,),
                  )
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Text(m.dateToString(supply.supplyDate), style: style),
                  const Spacer(),
                  Text("${supply.summ} \$", style: style)
                ]
              )
            ]
          )
        )
      ),
    );
  }
}

class AddSupplyContainer extends StatelessWidget {
  const AddSupplyContainer({
    Key? key, 
    required this.bloc, 
    required this.view
  }) : super(key: key);

  final SupplysBloc bloc;
  final m.DataView view;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: InkWell(
        onTap: () async {
          await showDialog(
            context: context,
            builder: (context) => const AddSupplyDialog()
          );
          bloc.add(SupplyLoadEvent());
        },
        child: SizedBox(
          width: 300,
          height: (view == m.DataView.grid) ? 100 : 80,
          child: const Center(
            child: Icon(Icons.add, size: 50, color: Colors.grey)
          )
        ),
      )
    );
  }
}