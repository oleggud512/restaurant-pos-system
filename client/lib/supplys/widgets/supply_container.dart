import 'package:flutter/material.dart';
import '../../services/models.dart';
import '../add_supply/add_supply.dart';
import '../show_supply/show_supply.dart';
import '../supplys_bloc.dart';
import '../supplys_states_events.dart';


class SupplyContainer extends StatelessWidget {
  SupplyContainer({Key? key, required this.supply, required this.view, required this.onTap}) : super(key: key);

  Supply supply;
  View view;
  void Function()? onTap;

  TextStyle style = const TextStyle(
    fontWeight: FontWeight.bold
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          width: 300, 
          height: (view == View.grid) ? 100 : 80,
          child: Column(
            children: [
              Row(
                children: [
                  Text("номер: "),
                  Text(supply.supplyId.toString(), style: style)
                ],
              ),
              Row(
                children: [
                  Text("постачальник: "),
                  Flexible(
                    child: Text("#" + supply.supplierId.toString() + " " + supply.supplierName, 
                      style: style, 
                      overflow: TextOverflow.ellipsis,),
                  )
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Text(dateToString(supply.supplyDate), style: style),
                  const Spacer(),
                  Text(supply.summ.toString() + " \$", style: style)
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
  AddSupplyContainer({Key? key, required this.bloc, required this.view}) : super(key: key);

  SupplysBloc bloc;
  final View view;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: InkWell(
        onTap: () async {
          await showDialog(
            context: context,
            builder: (context) => AddSupplyDialog()
          );
          bloc.inEvent.add(SupplyLoadEvent());
        },
        child: SizedBox(
          width: 300,
          height: (view == View.grid) ? 100 : 80,
          child: const Center(
            child: Icon(Icons.add, size: 50, color: Colors.grey)
          )
        ),
      )
    );
  }
}