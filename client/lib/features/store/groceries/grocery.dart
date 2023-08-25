import 'package:client/l10n/app_localizations.g.dart';
import 'package:flutter/material.dart';
import 'package:client/features/store/groceries/grocery_states_events.dart';
import 'package:client/widgets/gram_liter_dropdown.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../utils/bloc_provider.dart';
import '../../../utils/constants.dart';
import '../../../services/repo.dart';
import 'grocery_bloc.dart';

class GroceryDialog extends StatefulWidget {
  const GroceryDialog({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<GroceryDialog> createState() => _GroceryDialogState();
}

class _GroceryDialogState extends State<GroceryDialog> {
  late AppLocalizations l;


  @override
  Widget build(BuildContext context) {
    l = AppLocalizations.of(context)!;
    return BlocProvider(
      // bloc: GroceryBloc(Provider.of<Repo>(context),widget.id),
      create: (_) => GroceryBloc(Provider.of<Repo>(context),widget.id)..add(GrocLoadEvent()),
      child: Dialog(
        child: SizedBox(
          width: Constants.groceryDialogSize.width,
          height: Constants.groceryDialogSize.height,
          child: BlocBuilder<GroceryBloc, GroceryState>(
            builder: (context, state) {
              final bloc = context.readBloc<GroceryBloc>();
              if (state is GrocLoadingState) {
                return const Center(child: CircularProgressIndicator(),);
              } else if (state is GrocLoadedState || state is GrocEditState) {
                // var groc = state.grocery;
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      buildText(context, state, bloc),
                      buildTable(context, bloc),
                      buildCount(context, state, bloc),
                      const SizedBox(height: 10),
                      buildButtons(context, state, bloc),
                    ]
                  )
                );
              } 
              return Container();
            },
          ),
        ),
      )
    );
  }


  // в еdit state - edit, в loaded - text
  Widget buildText(BuildContext context, dynamic state, GroceryBloc bloc) {
    if (state is GrocLoadedState) {
      return Row(
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: Text(state.grocery.grocName, style: Theme.of(context).textTheme.titleLarge)
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Center(
              child: Text(l.measure(state.grocery.grocMeasure), style: Theme.of(context).textTheme.titleLarge)
            ),
          )
        ],
      );
    } else if (state is GrocEditState) {
      return Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              decoration: InputDecoration(
                labelText: l.name,
                border: const OutlineInputBorder()
              ),
              controller: TextEditingController(text: state.grocery.grocName),
              onChanged: (newVal) {
                bloc.add(GrocNameChanged(newVal));
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GramLiterDropdown(
              value: state.grocery.grocMeasure,
              onChanged: (newVal) {
                bloc.add(GrocMeasureChanged(newVal!));
              },
            )
          )
        ],
      );
    } return const Text("something wrong");
  }

  bool ascending = true;
  // везде одна и та же
  Widget buildTable(BuildContext context, GroceryBloc bloc) {
    return Expanded(
      child: DataTable(
        sortAscending: ascending,
        columns: [
          DataColumn(
            label: Text(l.supplier('1'), 
              style: const TextStyle(
                fontWeight: FontWeight.bold
              )
            )
          ),
          DataColumn(
            onSort: ((int columnIndex, bool _) {
              setState(() {
                bloc.grocery.suppliedBy.sort((a,b) {
                  if (a.supGrocPrice! == b.supGrocPrice!) {
                    return 0;
                  } else if (a.supGrocPrice! > b.supGrocPrice!) {
                    return 1;
                  } else {
                    return -1;
                  }
                });
                if (!ascending) bloc.grocery.suppliedBy = bloc.grocery.suppliedBy.reversed.toList();
                ascending = !ascending;
              });
            }),
            label: Text(l.price, 
              style: const TextStyle(fontWeight: FontWeight.bold)
            ), 
            numeric: true)
        ],
        rows: [
          for (int i = 0; i < bloc.grocery.suppliedBy.length; i++) DataRow(
            cells: [
              DataCell(Text(bloc.grocery.suppliedBy[i].supplierName)),
              DataCell(Text(bloc.grocery.suppliedBy[i].supGrocPrice.toString()))
            ]
          )
        ],
      ),
    );
  }

  Widget buildCount(BuildContext context, dynamic state, GroceryBloc bloc) {
    return Center(
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text("${l.left}: ", 
                style: const TextStyle(fontSize: 20)
              )
            )
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                if (state is GrocLoadedState) {
                  return Center(child: Text(state.grocery.avaCount.toString(), style: const TextStyle(
                    fontSize: 20, 
                  )));
                } else if (state is GrocEditState) {
                  return TextFormField(
                    decoration: InputDecoration(
                      labelText: l.count,
                      border: const OutlineInputBorder()
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                    ],
                    controller: TextEditingController(text: state.grocery.avaCount.toString()),
                    onChanged: (newVal) {
                      // сделать отклик на изменение количества
                      // потом наконец сделать сохранение
                      bloc.add(GrocCountChanged(newVal));
                    },
                  );
                } return const Text("something wrong");
              },
            )
          )
        ],
      )
    );
  }


  Widget buildButtons(BuildContext context, dynamic state, GroceryBloc bloc) {
    return Row(
      children: [
        (state is GrocLoadedState) ? ElevatedButton(
          child: const Icon(Icons.edit),
          onPressed: () {
            bloc.add(GrocEditEvent());
          },
        ) : ElevatedButton(
          child: const Icon(Icons.save),
          onPressed: () {
            bloc.add(GrocSaveEvent());
          }
        ),
        const Spacer(),
        ElevatedButton(
          child: const Text("OK"),
          onPressed: () {
            if (state is GrocLoadedState) Navigator.pop(context);
            
          },
        )
      ],
    );
  }

}