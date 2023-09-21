import 'package:client/l10n/app_localizations.g.dart';
import 'package:client/services/entities/grocery/grocery.dart';
import 'package:client/utils/extensions/string.dart';
import 'package:client/utils/extensions/widget.dart';
import 'package:client/utils/sizes.dart';
import 'package:client/widgets/yes_no_dialog.dart';
import 'package:flutter/material.dart';
import 'package:client/utils/bloc_provider.dart';
import 'package:client/features/store/suppliers/sup_states_events.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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

  // should be called under BlocBuilder<SupBloc, SupState>
  Future<void> deleteSupplier(BuildContext context, SupState state) async {
    // не отправляю событие а сразу выполняю логику здесь 
    // для того чтобы suppliers в store перезагружались только после удаления
    bool? save = await showDialog(
      context: context,
      builder: (contex) => YesNoDialog(
        title: Text("Delete supplier?".hc),
        onNo: () {
          Navigator.pop(contex, false);
        }, 
        onYes: () {
          Navigator.pop(contex, true);
        }
      )
    );
    if (save != null && save == true && mounted) {
      await context.read<Repo>().deleteSupplier(state.supplierId)
        .then((_) => Navigator.pop(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    l = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => SupBloc(Provider.of<Repo>(context), widget.id, widget.groceries)..add(SupLoadEvent()), 
      child: Dialog(
        child: Container(
          padding: const EdgeInsets.all(p16),
          width: 500, 
          height: 500,
          child: BlocBuilder<SupBloc, SupState>(
            builder: (context, state) {
              final bloc = context.readBloc<SupBloc>();
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Column(
                  children: [
                    Text(state.supplier!.supplierName),
                    buildTable(context, bloc, state),
                    buildButtons(context, bloc, state),
                  ],
                );
              }
            }
          )
        )
      )
    );
  }

  Widget buildTable(BuildContext context, SupBloc bloc, SupState state) {
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
                for (int i = 0; i < state.supplier!.groceries!.length; i++) Theme(
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
                          child: Text("удалить".hc),
                          onTap: () {
                            bloc.add(SupDeleteGroceryEvent(state.supplier!.groceries![i].grocId));
                          },
                        )
                      ];
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(child: Text(state.supplier!.groceries![i].grocName),)
                        ),
                        Expanded(
                          child: Center(child: Text(state.supplier!.groceries![i].supGrocPrice.toString()),)
                        )
                      ],
                    )
                  ),
                )
              ]
            ),
          ),
          if (state.isShowAddGrocForm) buildAddGroceryForm(context, bloc, state)
        ],
      ),
    );
  }

  Widget buildAddGroceryForm(BuildContext context, SupBloc bloc, SupState state) {
    return Card(
      elevation: 3.0,
      margin: const EdgeInsets.all(5),
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: DropdownButton<int?>(
                value: state.grocToAdd.grocId,
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text('Select a grocery'.hc)
                  ),
                  ...widget.groceries.map((e) => DropdownMenuItem(
                    value: e.grocId,
                    child: Text(e.grocName),
                  )).toList()
                ],
                onChanged: (newVal) {
                  bloc.add(ToAddGrocIdChanged(newVal));
                },
                isExpanded: true,
              )
            ),
            Expanded(
              child: TextFormField(
                inputFormatters: [ FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')) ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(p16),
                  hintText: 'price'.hc
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

  Widget buildButtons(BuildContext context, SupBloc bloc, SupState state) {
    return Row(
      children: [
        FilledButton(
          onPressed: () => deleteSupplier(context, state), 
          child: const Icon(Icons.delete)
        ).withTooltip("delete supplier".hc),

        w8gap,
        ...!state.isShowAddGrocForm 
          ? [
            FilledButton(
              onPressed: () {
                bloc.add(SupShowAddGroceryFormEvent());
              },
              child: const Icon(Icons.add)
            ).withTooltip("додати інгрeдієнт".hc)
          ] 
          : [ //                          |delete|saveGroc|hideForm|        |ok|
            FilledButton(
              child: const Icon(Icons.check),
              onPressed: () {
                bloc.add(SupAddGroceryEvent());
              }
            ),
            const SizedBox(width: 10),
            FilledButton(
              onPressed: () {
                bloc.add(SupHideAddGroceryFormEvent());
              }, 
              child: const Icon(Icons.close)
            ),
          ],

        const Spacer(),
        FilledButton(
          child: Text("OK".hc),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ]
    );
  }
}