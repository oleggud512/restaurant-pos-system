import 'package:client/features/supplys/add_supply/add_supply_events_states.dart';
import 'package:client/l10n/localizations_context_ext.dart';
import 'package:client/services/entities/grocery/grocery.dart';
import 'package:client/services/entities/supplier.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../utils/bloc_provider.dart';
import '../../../services/repo.dart';
import 'add_supply_bloc.dart';

class AddSupplyDialog extends StatefulWidget {
  const AddSupplyDialog({Key? key}) : super(key: key);

  @override
  State<AddSupplyDialog> createState() => _AddSupplyDialogState();
}

class _AddSupplyDialogState extends State<AddSupplyDialog> {

  Future<void> addSupply(BuildContext context, AddSupplyState state) async {
    // TODO: move validation out of here.
    // cannot supply if...
    // 1. Supplier is not selected
    if (state.supply.supplierId == null) return;
    // 2. Groceries are not selected
    if (state.supply.groceries.isEmpty) return;
    // 3. Didn't choose the amount of supply
    if (state.supply.groceries.where(
        (groc) => groc.grocCount == null || groc.grocCount == 0).isNotEmpty
    ) return;
    
    await context.read<Repo>().addSupply(state.supply);
    if (mounted) Navigator.pop(context);
  }

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
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(context.ll!.new_supply, style: Theme.of(context).textTheme.titleLarge)
                    ),
                    buildDropdownSumm(bloc, state),
                    Expanded(
                      child: SupplyConsistsContainer(
                        child: state.supplier != null 
                          ? buildSupplyContent(bloc) 
                          : Center(
                            child: Text(context.ll!.select_supplier_placeholder, style: TextStyle(
                              color: Colors.grey[500],
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                            ))
                          ),
                      ),
                    ),
                    FilledButton(
                      child: Text(context.ll!.supply('1')),
                      onPressed: () => addSupply(context, state)
                    )
                  ],
                ),
              );
            }
          )
        )
      )
    );
  }

  Widget buildDropdownSumm(AddSupplyBloc bloc, AddSupplyState state) {
    return Row(
      children: [
        DropdownButton<Supplier>(
          value: state.supplier,
          hint: Text(context.ll!.choose_supplier_hint),
          items: [
            DropdownMenuItem<Supplier>(
              value: null,
              child: Text(context.ll!.no_supplier_selected_placeholder), 
            ),
            ...state.suppliers.map((s) => DropdownMenuItem<Supplier>(
              value: s,
              child: Text(s.supplierName),
            )).toList()
          ],
          onChanged: (newVal) {
            bloc.add(AddSupplySupplierSelectedEvent(newVal));
          }
        ),
        const Spacer(),
        Text(context.ll!.amount(state.totalSupplySumm))
      ],
    );
  }

  Widget buildSupplyContent(AddSupplyBloc bloc) {
    final popupKey = GlobalKey<PopupMenuButtonState>();
    return ListView(
      children:[
        for (final groc in bloc.state.supply.groceries) Padding(
          padding: const EdgeInsets.all(3.0),
          child: PopupMenuButton(
            tooltip: '',
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text(context.ll!.delete), 
                onTap: () {
                  bloc.add(AddSupplyRemoveGrocFromSupply(groc.grocId!));
                },
              )
            ],
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(groc.grocName!, style: const TextStyle(
                    fontWeight: FontWeight.bold
                  ))
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(Constants.decimalValueRegExp)
                    ],
                    onChanged: (newVal) {
                      bloc.add(AddSupplyNewCountEvent(groc, newVal));
                    },
                  ),
                ),
              ]
            ),
          ),
        ),
        PopupMenuButton<Grocery>(
          key: popupKey,
          tooltip: context.ll!.select_grocery_tooltip,
          itemBuilder: (context) {
            return [
              for (final groc in bloc.state.supplier!.groceries) PopupMenuItem(
                value: groc,
                child: Text("${groc.grocName} || ${groc.supGrocPrice}"),
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: p16),
      child: Padding(
        padding: const EdgeInsets.all(p16),
        child: child,
      )
    );
  }
}