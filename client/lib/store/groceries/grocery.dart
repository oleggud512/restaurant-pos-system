import 'package:flutter/material.dart';
import 'package:client/store/groceries/grocery_states_events.dart';
import 'package:client/store/store_bloc.dart';
import 'package:client/store/store_states_events.dart';
import 'package:client/store/widgets/my_text_field.dart';
import 'package:client/widgets/gram_liter_dropdown.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../bloc_provider.dart';
import '../../services/constants.dart';
import '../../services/models.dart';
import '../../services/repo.dart';
import 'grocery_bloc.dart';

class GroceryDialog extends StatefulWidget {
  const GroceryDialog({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<GroceryDialog> createState() => _GroceryDialogState();
}

class _GroceryDialogState extends State<GroceryDialog> {
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // bloc: GroceryBloc(Provider.of<Repo>(context),widget.id),
      blocBuilder: () => GroceryBloc(Provider.of<Repo>(context),widget.id),
      blocDispose: (GroceryBloc bloc) => bloc.dispose(),
      child: Builder(
        builder: (context) {
          var bloc = BlocProvider.of<GroceryBloc>(context);
          
          return Dialog(
            child: SizedBox(
              width: Provider.of<Constants>(context).groceryDialogSize.width,
              height: Provider.of<Constants>(context).groceryDialogSize.height,
              child: StreamBuilder(
                stream: bloc.outState,
                builder: (context, snapshot) {
                  var state = snapshot.data;
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
          );
        }
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
              child: Text(state.grocery.grocName, style: Theme.of(context).textTheme.headline6)
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Center(
              child: Text((state.grocery.grocMeasure == 'gram')? "кг": "литр", style: Theme.of(context).textTheme.headline6)
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
              decoration: const InputDecoration(
                labelText: "назва",
                border: OutlineInputBorder()
              ),
              controller: TextEditingController(text: state.grocery.grocName),
              onChanged: (newVal) {
                bloc.inEvent.add(GrocNameChanged(newVal));
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GramLiterDropdown(
              value: state.grocery.grocMeasure,
              onChanged: (newVal) {
                bloc.inEvent.add(GrocMeasureChanged(newVal!));
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
            label: Text("постачальник", 
              style: TextStyle(
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
            label: Text("ціна", 
              style: TextStyle(
                fontWeight: FontWeight.bold
              )
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
          const Expanded(
            child: Center(
              child: Text("Залишилося: ", 
                style: TextStyle(
                  fontSize: 20,       
                )
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
                    decoration: const InputDecoration(
                      labelText: "кількість",
                      border: OutlineInputBorder()
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
                    ],
                    controller: TextEditingController(text: state.grocery.avaCount.toString()),
                    onChanged: (newVal) {
                      // сделать отклик на изменение количества
                      // потом наконец сделать сохранение
                      bloc.inEvent.add(GrocCountChanged(newVal));
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
            bloc.inEvent.add(GrocEditEvent());
          },
        ) : ElevatedButton(
          child: const Icon(Icons.save),
          onPressed: () {
            bloc.inEvent.add(GrocSaveEvent());
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