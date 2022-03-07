import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../bloc_provider.dart';
import '../../services/models.dart';
import '../../services/repo.dart';
import 'add_dish_bloc.dart';
import 'add_dish_states_events.dart';


class AddDishPage extends StatefulWidget {
  AddDishPage({Key? key, required this.groups}) : super(key: key);

  List<DishGroup> groups;

  @override
  State<AddDishPage> createState() => _AddDishPageState();
}

class _AddDishPageState extends State<AddDishPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider<AddDishBloc>(
        blocBuilder: () => AddDishBloc(
          Provider.of<Repo>(context),
          widget.groups
        ),
        blocDispose: (AddDishBloc bloc) => bloc.dispose(),
        child: Builder(
          builder: (context) {
            AddDishBloc bloc = BlocProvider.of<AddDishBloc>(context);
            return StreamBuilder(
              stream: bloc.outState,
              builder: (context, snapshot) {
                var state = snapshot.data;
                if (state is AddDishLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AddDishLoadedState) {
                  return buildTempContent(bloc, state);
                } return Container();
              }
            );
          } 
        ),
      )
    );
  }

  Widget buildTempContent(AddDishBloc bloc, AddDishLoadedState state) {
    return Row(
      children: [
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: "dish name",
              ),
              onChanged: (String newVal) {
                bloc.inEvent.add(AddDishNameChangedEvent(newVal));
              }
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "dish price",
              ),
              onChanged: (String newVal) {
                bloc.inEvent.add(AddDishPriceChangedEvent(newVal));
              }
            ),
            Row(
              children: [
                Expanded(child: Text("PRIME COST: ")),
                Expanded(
                  child: StreamBuilder(
                    stream: bloc.outPrimeCost,
                    builder: (context, snapshot) {
                      var state = snapshot.data;
                      if (state is AddDishPrimeCostLoadingState) {
                        return const Center(child: CircularProgressIndicator(),);
                      } else if (state is AddDishPrimeCostLoadedState) {
                        return Center(child: Text('${bloc.primeCost}'),);
                      }
                      return Container();
                    }
                  ),
                ),
              ],
            ),
            DropdownButton<int>(
              value: bloc.dish.dishGrId,
              items: [
                for (int i = 0; i < bloc.dishGroups.length; i++) DropdownMenuItem(
                  child: Text(bloc.dishGroups[i].groupName),
                  value: bloc.dishGroups[i].groupId
                )
              ],
              onChanged: (newVal) {
                bloc.inEvent.add(AddDishGroupChanged(newVal!));
              },
            ),
            ElevatedButton(
              onPressed: () async {
                print(bloc.dish.toJson());
                await Provider.of<Repo>(context, listen: false).addDish(bloc.dish);
                Navigator.pop(context);
              }, 
              child: const Text("add")
            )
          ],
        ),),
        Expanded(child: ListView(
          children: [
            for (int i = 0; i < bloc.dish.dishGrocs.length; i++) Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(5.0))
                  ),
                  height: 20,
                  width: 20,
                  child: InkWell(
                    onTap: () {
                      bloc.inEvent.add(AddDishRemoveGrocEvent(i));
                    },
                    child: const Icon(Icons.close, size: 15)
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Center(child: Text(bloc.dish.dishGrocs[i].grocName))
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "count",

                      ),
                      onChanged: (newVal) {
                        bloc.inEvent.add(AddDishDishGrocCountChangedEvent(bloc.dish.dishGrocs[i].grocId, newVal));
                      },
                    ),
                  )
                )
              ],
            )
          ],
        ),),
        Expanded(child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "name",
                  border: OutlineInputBorder()
                ),
                onChanged: (newVal) {
                  bloc.inEvent.add(AddDishFindGrocEvent(newVal)); // поиск / фильтрация
                }
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int i = 0; i < state.groceries.length; i++) InkWell(
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        child: Text(state.groceries[i].grocName)
                      ),
                      onTap: () {
                        bloc.inEvent.add(AddDishAddGrocEvent(state.groceries[i]));
                      }
                    )
                  ],
                )
              ),
            ),
          ],
        ),)
      ]
    );
  }
}

