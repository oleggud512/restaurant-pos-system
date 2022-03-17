import 'dart:io';

import 'package:client/menu/add_dish/prime_cost_details/prime_cost_details_dialog.dart';
import 'package:client/menu/widgets/groc_picker.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../bloc_provider.dart';
import '../../services/constants.dart';
import '../../services/models.dart';
import '../../services/repo.dart';
import '../widgets/group_picker.dart';
import '../widgets/label_icon_button.dart';
import '../widgets/photo.dart';
import 'dish_details_bloc.dart';
import 'dish_details_states_events.dart';

class DishDetalsPage extends StatefulWidget {
  DishDetalsPage({Key? key, required this.dish, required this.groups}) : super(key: key);

  List<DishGroup> groups;
  Dish dish;

  @override
  State<DishDetalsPage> createState() => _DishDetalsPageState();
}

class _DishDetalsPageState extends State<DishDetalsPage> {
  

  @override
  Widget build(BuildContext context) {
    
    return BlocProvider<DishDtBloc>(
      blocBuilder: () => DishDtBloc(Provider.of<Repo>(context), widget.dish, widget.groups),
      blocDispose: (DishDtBloc bloc) => bloc.dispose(),
      child: Builder(
        builder: (context) {
          var bloc = BlocProvider.of<DishDtBloc>(context);
          return StreamBuilder<Object>(
            stream: bloc.outState,
            builder: (context, snapshot) {
              var state = snapshot.data;
              if (state is DishDtLoadingState) {
                return Scaffold(appBar: AppBar(), body: Center(child: CircularProgressIndicator()));
              } else if (state is DishDtLoadedState) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(bloc.groups.firstWhere((e) => e.groupId == bloc.dish.dishGrId).groupName + ": " + bloc.dish.dishName),
                    actions: [
                      IconButton(
                        icon: (!bloc.isEdit) ? const Icon(Icons.mode_edit_outline) : const Icon(Icons.view_compact_rounded),
                        onPressed: () {
                          bloc.inEvent.add(DishDtEditEvent());
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
          );
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
          DataColumn(label: Text("grocery", style: Provider.of<Constants>(context, listen: false).boldText)),
          DataColumn(numeric: true, label: Text("count", style: Provider.of<Constants>(context, listen: false).boldText))
        ], 
        rows: [
          for (var groc in bloc.dish.dishGrocs) DataRow(
            cells: [
              DataCell(Text(groc.grocId.toString() + " " + groc.grocName)),
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
          child: FutureBuilder(
            future: Dio().get('http://127.0.0.1:5000/static/descr/0.md'),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.toString());
              } return Container();
            }
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
                labelText: "Name"
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
                      labelText: "Price"
                    )
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    child: Text("prime cost", overflow: TextOverflow.ellipsis),
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
              child: Text('save'),
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