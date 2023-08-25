import 'package:client/l10n/app_localizations.g.dart';
import 'package:client/widgets/yes_no_dialog.dart';
import 'package:flutter/material.dart';
import 'package:client/utils/bloc_provider.dart';
import 'package:client/features/store/suppliers/sup_states_events.dart';
import 'package:provider/provider.dart';

import '../../../services/models.dart';
import '../../../services/repo.dart';
import 'sup_bloc.dart';


class SupplierDetailsDialog extends StatefulWidget {
  const SupplierDetailsDialog({Key? key, required this.id, required this.groceries}) : super(key: key);

  final int id;
  final List<Grocery> groceries;

  @override
  State<SupplierDetailsDialog> createState() => _SupplierDetailsDialogState();
}

class _SupplierDetailsDialogState extends State<SupplierDetailsDialog> {
  late AppLocalizations l;


  @override
  Widget build(BuildContext context) {
    l = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => SupBloc(Provider.of<Repo>(context), widget.id, widget.groceries)..add(SupLoadEvent()), 
      child: Dialog(
        child: Container(
          padding: const EdgeInsets.all(10),
          width: 500, 
          height: 500,
          child: BlocBuilder<SupBloc, SupState>(
            builder: (context, state) {
              final bloc = context.readBloc<SupBloc>();
              if (state is SupLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SupLoadedState) {
                return Column(
                  children: [
                    Text(bloc.supplier.supplierName),
                    buildTable(context, bloc, state),
                    buildButtons(context, bloc, state),
                  ],
                );
              } return Container();
            }
          )
        )
      )
    );
  }

  Widget buildTable(BuildContext context, SupBloc bloc, dynamic state) {
    // if state is Loaded - Text, state is Edit - TextField
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Center(child: Text(l.grocery(2))),
                    ),
                    Expanded(
                      child: Center(child: Text(l.price)),
                    )
                  ],
                ),
                for (int i = 0; i < bloc.supplier.groceries!.length; i++) Theme(
                  data: Theme.of(context).copyWith(
                    tooltipTheme: const TooltipThemeData(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                    )
                  ),
                  child: PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: const Text("удалить"),
                          onTap: () {
                            bloc.add(SupDeleteGroceryEvent(bloc.supplier.groceries![i].grocId));
                          },
                        )
                      ];
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(child: Text(bloc.supplier.groceries![i].grocName),)
                        ),
                        Expanded(
                          child: Center(child: Text(bloc.supplier.groceries![i].supGrocPrice.toString()),)
                        )
                      ],
                    )
                  ),
                )
              ]
            ),
          ),
          if (bloc.showAddGrocForm) buildAddGroceryForm(context, bloc, state)
        ],
      ),
    );
  }

  Widget buildAddGroceryForm(BuildContext context, SupBloc bloc, dynamic state) {
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.all(5),
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: DropdownButton<int>(
                value: bloc.toAddGroc.grocId ?? widget.groceries[0].grocId,
                items: widget.groceries.map((e) => DropdownMenuItem(
                  value: e.grocId,
                  child: Text(e.grocName),
                )).toList(),
                onChanged: (newVal) {
                  bloc.add(ToAddGrocIdChanged(newVal!));
                },
                isExpanded: true,
              )
            ),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  // hintText: 'введіть назву інгредієнту',
                ),
                onChanged: (newVal) {
                  bloc.add(ToAddGrocCountChanged(newVal));
                },
              )
            )
          ],
        ),
      )
    );
  }

  Widget buildButtons(BuildContext context, SupBloc bloc, dynamic state) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () async {
            // не отправляю событие а сразу выполняю логику здесь 
            // для того чтобы suppliers в store перезагружались только после удаления
            bool? save = await showDialog(
              context: context,
              builder: (contex) => YesNoDialog(
                title: const Text("Delete supplier?"),
                onNo: () {
                  Navigator.pop(contex, false);
                }, 
                onYes: () {
                  Navigator.pop(contex, true);
                }
              )
            );
            if (save != null && save == true) {
              await Provider.of<Repo>(context, listen: false).deleteSupplier(bloc.supplierId);
              Navigator.pop(context);
            }
          }, 
          child: const Icon(Icons.delete)
        ),
        const SizedBox(width: 10),
        ...(!bloc.showAddGrocForm) ? [
          Tooltip( //                     |delete|addGroc |                 |ok|
            message: "додати інгрeдієнт",
            child: ElevatedButton(
              onPressed: () {
                bloc.add(SupShowAddGroceryFormEvent());
              },
              child: const Icon(Icons.add)
            )
          )
        ] : [ //                          |delete|saveGroc|hideForm|        |ok|
          ElevatedButton(
            child: const Icon(Icons.check),
            onPressed: () {
              bloc.add(SupAddGroceryEvent());
            }
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              bloc.add(SupHideAddGroceryFormEvent());
            }, 
            child: const Icon(Icons.close)
          ),
        ],

        const Spacer(),
        ElevatedButton(
          child: const Text("OK"),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ]
    );
  }
}