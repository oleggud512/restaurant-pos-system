import 'package:client/features/supplys/add_supply/add_supply_events_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../utils/bloc_provider.dart';
import '../../../services/models.dart';
import '../../../services/repo.dart';
import 'add_supply_bloc.dart';


class AddSupplyDialog extends StatefulWidget {
  const AddSupplyDialog({Key? key}) : super(key: key);

  @override
  State<AddSupplyDialog> createState() => _AddSupplyDialogState();
}

class _AddSupplyDialogState extends State<AddSupplyDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddSupplyBloc>(
      create: (context) => AddSupplyBloc(context.read<Repo>())
        ..add(AddSupplyLoadEvent()),
      child: Dialog(
        child: SizedBox(
          width: 500,
          height: 500,
          child: BlocBuilder<AddSupplyBloc, AddSupplyState>(
            builder: (context, state) {
              final bloc = context.readBloc<AddSupplyBloc>();
              if (state is AddSupplyLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is AddSupplyLoadedState) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Text("supply", style: Theme.of(context).textTheme.titleLarge)
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
                      FilledButton(
                        child: const Text("supply"),
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
      )
    );
  }

  Widget buildDropdownSumm(AddSupplyBloc bloc, AddSupplyLoadedState state) {
    return Row(
      children: [
        DropdownButton<Supplier>(
          value: bloc.supplier,
          hint: const Text("choose supplier"),
          items: [
            const DropdownMenuItem(
              value: null,
              child: Text("choose supplier"), 
            ),
            ...state.suppliers.map((s) => DropdownMenuItem(
              value: s,
              child: Text(s.supplierName),
            )).toList()
          ],
          onChanged: (newVal) {
            bloc.add(AddSupplySupplierSelectedEvent(newVal));
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
                child: const Text("delete"), 
                onTap: () {
                  bloc.add(AddSupplyRemoveGrocFromSupply(bloc.supply.groceries[i].grocId!));
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
                      bloc.add(AddSupplyNewCount(i, newVal));
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
                value: bloc.supplier!.groceries![i],
                child: Text("${bloc.supplier!.groceries![i].grocName} || ${bloc.supplier!.groceries![i].supGrocPrice}"),
              )
            ];
          },
          onSelected: (newVal) {
            bloc.add(AddSupplyAddGrocToSupply(newVal));
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
  const SupplyConsistsContainer({Key? key, this.child}) : super(key: key);

  final Widget? child;

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