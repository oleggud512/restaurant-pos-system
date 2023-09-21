import 'dart:io';

import 'package:client/features/menu/add_dish/add_dish.dart';
import 'package:client/features/menu/add_dish/prime_cost_details/prime_cost_details_dialog.dart';
import 'package:client/features/menu/widgets/groc_picker.dart';
import 'package:client/router.dart';
import 'package:client/services/entities/dish.dart';
import 'package:client/services/entities/dish_group.dart';
import 'package:client/utils/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/bloc_provider.dart';
import '../../../l10n/app_localizations.g.dart';
import '../../../utils/constants.dart';
import '../../../services/repo.dart';
import '../widgets/text_editor.dart';
import 'dish_details_bloc.dart';
import 'dish_details_states_events.dart';


class DishDetailsRouteArgs extends Equatable {
  final int dishId;

  const DishDetailsRouteArgs({required this.dishId});

  @override
  List<Object?> get props => [
    dishId
  ];
}


class DishDetalsPage extends StatefulWidget {
  const DishDetalsPage({Key? key, required this.dishId}) : super(key: key);

  final int dishId;

  @override
  State<DishDetalsPage> createState() => _DishDetalsPageState();
}

class _DishDetalsPageState extends State<DishDetalsPage> {
  late AppLocalizations l;

  Future<void> onEdit(BuildContext context) async {
    final bloc = context.readBloc<DishDtBloc>();
    await Navigator.of(context).pushNamed(MenuPageRoute.dishEditRoute(bloc.dish.dishId),
      arguments: EditDishRouteArgs(dish: bloc.dish)
    );
    bloc.add(DishDtLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
    l = AppLocalizations.of(context)!;
    return BlocProvider<DishDtBloc>(
      create: (_) => DishDtBloc(context.read<Repo>(), widget.dishId)
        ..add(DishDtLoadEvent()),
      child: BlocBuilder<DishDtBloc, DishDtState>(
        builder: (context, state) {
          final bloc = context.readBloc<DishDtBloc>();
          if (state is DishDtLoadingState) {
            return Scaffold(appBar: AppBar(automaticallyImplyLeading: false,), body: const Center(child: CircularProgressIndicator()));
          } else if (state is DishDtLoadedState) {
            return Scaffold(
              key: key,
              appBar: AppBar(
                title: Text("${bloc.groups.isNotEmpty // TODO: (3)
                  ? bloc.groups.firstWhere((e) => e.groupId == bloc.dish.dishGrId).groupName
                  : '[unknown group]'}: ${bloc.dish.dishName}"),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.mode_edit_outline),
                    onPressed: () => onEdit(context)
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
          // child: Photo(dish: bloc.dish, edit: bloc.isEdit)
          child: bloc.dish.dishPhotoUrl.isNotEmpty
              ? Image.network(bloc.dish.dishPhotoUrl)
              : Image.asset('assets/dish_placeholder.jpeg')
        ),
        Expanded(
          flex: 2,
          child: (!bloc.isEdit) ? buildGrocShow(bloc, state) : buildGrocEdit(bloc, state)
        )
      ]
    );
  }

  Widget buildGrocShow(DishDtBloc bloc, DishDtLoadedState state) {
    return SingleChildScrollView(
      child: DataTable(
        columns: [
          DataColumn(label: Text(l.grocery(1), style: Constants.boldText)),
          DataColumn(numeric: true, label: Text(l.count, style: Constants.boldText))
        ], 
        rows: [
          for (var groc in bloc.dish.dishGroceries) DataRow(
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
    return GrocPicker(grocCurState: bloc.dish.dishGroceries,);
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
              onChanged: (newVal) => bloc.dish = bloc.dish.copyWith(
                dishDescr: newVal
              ),
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
                bloc.dish = bloc.dish.copyWith(
                  dishName: newVal
                );
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
                      bloc.dish = bloc.dish.copyWith(
                        dishPrice: () => double.parse(newVal.isEmpty ? '0.0' : newVal)
                      );
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
            // TODO: (3) create dish group picker widget
            const Spacer(),
            if (bloc.isEdit) ElevatedButton(
              child: Text(l.save),
              onPressed: () async {
                if (!bloc.dish.isSaveable) return;
                // TODO move updateDish call to bloc away from widget tree
                await Provider.of<Repo>(context, listen: false).updateDish(bloc.dish);
                Navigator.pop(context);
              },
            )
          ],
      ),
    );
  }
}