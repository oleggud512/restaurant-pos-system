import 'dart:io';

import 'package:client/features/menu/add_dish/prime_cost_details/prime_cost_details_dialog.dart';
import 'package:client/features/menu/widgets/groc_picker.dart';
import 'package:client/services/entities/dish.dart';
import 'package:client/services/entities/dish_group.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/bloc_provider.dart';
import '../../../l10n/app_localizations.g.dart';
import '../../../utils/constants.dart';
import '../../../services/repo.dart';
import '../widgets/group_picker.dart';
import '../widgets/photo.dart';
import '../widgets/text_editor.dart';
import 'dish_details_bloc.dart';
import 'dish_details_states_events.dart';

class DishDetalsPage extends StatefulWidget {
  const DishDetalsPage({Key? key, required this.dish, required this.groups}) : super(key: key);

  final List<DishGroup> groups;
  final Dish dish;

  @override
  State<DishDetalsPage> createState() => _DishDetalsPageState();
}

class _DishDetalsPageState extends State<DishDetalsPage> {
  late AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
    l = AppLocalizations.of(context)!;
    return BlocProvider<DishDtBloc>(
      create: (_) => DishDtBloc(Provider.of<Repo>(context), widget.dish, widget.groups)..add(DishDtLoadEvent()),
      child: BlocBuilder<DishDtBloc, DishDtState>(
        builder: (context, state) {
          final bloc = context.readBloc<DishDtBloc>();
          if (state is DishDtLoadingState) {
            return Scaffold(appBar: AppBar(automaticallyImplyLeading: false,), body: const Center(child: CircularProgressIndicator()));
          } else if (state is DishDtLoadedState) {
            return Scaffold(
              key: key,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => key.currentState!.openDrawer()
                  ),
                  const BackButton(),
                  Expanded(child: Center(child: Text(
                    "${bloc.groups.firstWhere((e) => e.groupId == bloc.dish.dishGrId).groupName}: ${bloc.dish.dishName}", 
                    style: Theme.of(context).appBarTheme.titleTextStyle
                  ))),
                  IconButton(
                    icon: (!bloc.isEdit) ? const Icon(Icons.mode_edit_outline) : const Icon(Icons.view_compact_rounded),
                    onPressed: () {
                      bloc.add(DishDtEditEvent());
                    }
                  )
                ]
              ),
              body: Column(
                children: [
                  Expanded(child: buildFirstRow(bloc, state)),
                  Expanded(child: buildSecondRow(bloc, state))
                ],
              )
            );
          }
          return Container();
        }
      )
    );
  }

  Widget buildFirstRow(DishDtBloc bloc, DishDtLoadedState state) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Photo(dish: bloc.dish, edit: bloc.isEdit)
        ),
        Expanded(
          flex: 2,
          child: (!bloc.isEdit) ? buildGrocShow(bloc, state) : buildGrocEdit(bloc, state)
        )
      ]
    );
  }

  Future<void> setPhoto(DishDtBloc bloc) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) { return; }
    File file = File(result.files.single.path!);
    setState(() {
      bloc.dish.photo = file;
    });
  }

  Widget buildGrocShow(DishDtBloc bloc, DishDtLoadedState state) {
    return SingleChildScrollView(
      child: DataTable(
        columns: [
          DataColumn(label: Text(l.grocery(1), style: Constants.boldText)),
          DataColumn(numeric: true, label: Text(l.count, style: Constants.boldText))
        ], 
        rows: [
          for (var groc in bloc.dish.dishGrocs) DataRow(
            cells: [
              DataCell(Text("${groc.grocId} ${groc.grocName}")),
              DataCell(Text(groc.grocCount.toString()))
            ]
          )
        ]
      ),
    );
  }

  Widget buildGrocEdit(DishDtBloc bloc, DishDtLoadedState state) {
    return GrocPicker(grocCurState: bloc.dish.dishGrocs,);
  }

  Widget buildSecondRow(DishDtBloc bloc, DishDtLoadedState state)  {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: buildInfo(bloc, state)
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextEditor(
              text: bloc.dish.dishDescr, 
              isEdit: bloc.isEdit, 
              onChanged: (newVal) => bloc.dish.dishDescr = newVal,
            ),
          )
        )
      ],
    );
  }

  Widget buildInfo(DishDtBloc bloc, DishDtLoadedState state) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              enabled: bloc.isEdit,
              controller: TextEditingController(text: bloc.dish.dishName),
              onChanged: (newVal) {
                bloc.dish.dishName = newVal;
              },
              decoration: InputDecoration(
                labelText: l.name
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    enabled: bloc.isEdit,
                    controller: TextEditingController(text: bloc.dish.dishPrice.toString()),
                    onChanged: (newVal) {
                      bloc.dish.dishPrice = double.parse(newVal.isEmpty ? '0.0' : newVal);
                    },
                    decoration: InputDecoration(
                      labelText: l.price
                    )
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    child: Text(l.prime_cost, overflow: TextOverflow.ellipsis),
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return PrimeCostDetailsDialog(dish: bloc.dish);
                        }
                      );
                    },
                  ),
                )
              ],
            ),
            GroupPicker(
              enable: bloc.isEdit,
              value: bloc.dish.dishGrId,
              groups: bloc.groups,
              onChanged: (newVal) {
                setState(() {
                  bloc.dish.dishGrId = newVal!;
                });
              }
            ),
            const Spacer(),
            if (bloc.isEdit) ElevatedButton(
              child: Text(l.save),
              onPressed: () async {
                if (bloc.dish.isSaveable) {
                  await Provider.of<Repo>(context, listen: false).updateDish(bloc.dish);
                  Navigator.pop(context);
                }
              },
            )
          ],
      ),
    );
  }
}