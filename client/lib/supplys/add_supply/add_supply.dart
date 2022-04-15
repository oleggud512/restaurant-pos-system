import 'package:client/supplys/add_supply/add_supply_events_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Text("supply", style: Theme.of(context).textTheme.headline6)
                          ),
                          buildDropdownSumm(bloc, state),
                          Expanded(
                            child: SupplyConsistsContainer(
                              child: (bloc.supplier != null) ? buildSupplyContent(bloc) : Center(
                                child: Text("select supplier", style: TextStyle(
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                                ))
                              ),
                            ),
                          ),
                          ElevatedButton(
                            child: Text("supply"),
                            onPressed: () async {
                              if (bloc.supply.supplierId != null && bloc.supply.groceries.isNotEmpty &&
                                bloc.supply.groceries.where(
                                  (element) => element.grocCount == null || element.grocCount == 0).isEmpty
                                ) {
                                await Provider.of<Repo>(context, listen: false).addSupply(bloc.supply);
                                Navigator.pop(context);
                              }
                              
                            }
                          )
                        ],
                      ),
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

  Widget buildDropdownSumm(AddSupplyBloc bloc, dynamic state) {
    return Row(
      children: [
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
        const Spacer(),
        Text("summ: ${bloc.supply.summ}")
      ],
    );
  }

  Widget buildSupplyContent(AddSupplyBloc bloc) {
    return ListView(
      children:[
        for (int i = 0; i < bloc.supply.groceries.length; i++) Padding(
          padding: const EdgeInsets.all(3.0),
          child: PopupMenuButton(
            tooltip: '',
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("delete"), 
                onTap: () {
                  bloc.inEvent.add(AddSupplyRemoveGrocFromSupply(bloc.supply.groceries[i].grocId!));
                },
              )
            ],
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(bloc.supply.groceries[i].grocName!, style: const TextStyle(
                    fontWeight: FontWeight.bold
                  ))
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}'))
                    ],
                    onChanged: (newVal) {
                      bloc.inEvent.add(AddSupplyNewCount(i, newVal));
                    },
                  ),
                ),
              ]
            ),
          ),
        ),
        PopupMenuButton<Grocery>(
          tooltip: '',
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
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              alignment: Alignment.center,
              child: const Icon(Icons.add)
            ),
          ),
        )
      ]
    );
  }
}


class SupplyConsistsContainer extends StatelessWidget {
  SupplyConsistsContainer({Key? key, this.child}) : super(key: key);

  Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10)
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: child
    );
  }
}