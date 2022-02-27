import 'package:client/supplys/add_supply/add_supply_events_states.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../bloc_provider.dart';
import '../../services/models.dart';
import '../../services/repo.dart';
import 'add_supply_bloc.dart';


class AddSupplyDialog extends StatefulWidget {
  AddSupplyDialog({Key? key}) : super(key: key);

  @override
  State<AddSupplyDialog> createState() => _AddSupplyDialogState();
}

class _AddSupplyDialogState extends State<AddSupplyDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddSupplyBloc>(
      blocBuilder: () => AddSupplyBloc(Provider.of<Repo>(context)),
      blocDispose: (AddSupplyBloc bloc) => bloc.dispose(),
      child: Builder(
        builder: (context) {
          var bloc = BlocProvider.of<AddSupplyBloc>(context);
          return Dialog(
            child: SizedBox(
              width: 500,
              height: 500,
              child: StreamBuilder(
                stream: bloc.outState,
                builder: (context, snapshot) {
                  var state = snapshot.data;
                  if (state is AddSupplyLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AddSupplyLoadedState) {
                    return ListView(
                      children: [
                        const Text("supply"),
                        DropdownButton<Supplier>(
                          value: (bloc.supplier != null) ? bloc.supplier : null,
                          hint: const Text("choose supplier"),
                          items: [
                            const DropdownMenuItem(child: Text("none"), value: null),
                            for (int i = 0; i < state.suppliers.length; i++) DropdownMenuItem(
                              child: Text(state.suppliers[i].supplierName),
                              value: state.suppliers[i]
                            )
                          ],
                          onChanged: (newVal) {
                            bloc.inEvent.add(AddSupplySupplierSelectedEvent(newVal));
                          }
                        ),
                        Container(
                          color: Colors.lightBlue,
                          child: (bloc.supplier != null) ? Container(
                            padding: const EdgeInsets.all(10),
                            color: Colors.green[200],
                            height: 200,
                            child: ListView(
                              children:[
                                for (int i = 0; i < bloc.supply.groceries.length; i++) SizedBox(
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Expanded(child: Text(bloc.supply.groceries[i].grocName!)),
                                      Expanded(
                                        child: TextField(
                                          onChanged: (newVal) {
                                            bloc.inEvent.add(AddSupplyNewCount(i, newVal));
                                          },
                                        ),
                                      ),
                                    ]
                                  ),
                                ),
                                PopupMenuButton<Grocery>(
                                  itemBuilder: (context) {
                                    return [
                                      for (int i = 0; i < bloc.supplier!.groceries!.length; i++) PopupMenuItem(
                                        child: Text(
                                          bloc.supplier!.groceries![i].grocName + " || " + 
                                          bloc.supplier!.groceries![i].supGrocPrice.toString()
                                        ),
                                         value: bloc.supplier!.groceries![i],
                                      )
                                    ];
                                  },
                                  onSelected: (newVal) {
                                    bloc.inEvent.add(AddSupplyAddGrocToSupply(newVal));
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    color: Colors.red,
                                    child: const Icon(Icons.add)
                                  ),
                                )
                              ]
                            )
                          ) : const Text("select supplier")
                        ),
                        Row(
                          children: [
                            Text("summ: ${bloc.summ}"), 
                            const Spacer(),
                            ElevatedButton(
                              child: Text("supply"),
                              onPressed: () async {
                                print(bloc.supply.toJson());
                                if (bloc.supply.supplierId != null && bloc.supply.groceries.isNotEmpty) {
                                  await Provider.of<Repo>(context, listen: false).addSupply(bloc.supply);
                                }
                                Navigator.pop(context);
                              }
                            )
                          ],
                        )
                      ],
                    );
                  } return Container();
                }
              )
            )
          );
        }
      )
    );
  }
}