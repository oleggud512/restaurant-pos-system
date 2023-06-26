
import 'package:client/l10nn/app_localizations.dart';
import 'package:client/orders/add_order/add_order_states_events.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../bloc_provider.dart';
import '../../services/models.dart';
import '../../services/repo.dart';
import 'add_order_bloc.dart';


class AddOrderPage extends StatefulWidget {
  AddOrderPage({Key? key, required this.dishes, required this.dishGroups}) : super(key: key);

  List<Dish> dishes;
  List<DishGroup> dishGroups;

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  late AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    l = AppLocalizations.of(context)!;
    return BlocProvider<AddOrderBloc>(
      blocBuilder: () => AddOrderBloc(Provider.of<Repo>(context, listen: false), widget.dishes, widget.dishGroups),
      blocDispose: (AddOrderBloc bloc) => bloc.dispose(),
      child: Builder(
        builder: (context) {
          var bloc = BlocProvider.of<AddOrderBloc>(context);
          return StreamBuilder(
            stream: bloc.outState,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              var state = snapshot.data;
              if (state is AddOrderLoadingState) {
                return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
              } else if (state is AddOrderLoadedState) {
                return Scaffold(
                  appBar: AppBar(),
                  body: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: buildFirstColumn(bloc)
                        ),
                        Expanded(
                          child: buildSecondColumn(bloc)
                        )
                      ],
                    ),
                  )
                );
              } return Container();
            },
          );
        },
      )
    );
  }


  Widget buildFirstColumn(AddOrderBloc bloc) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
          child: DropdownButton<int>(
            isExpanded: true,
            value: bloc.order.empId,
            items: [
              const DropdownMenuItem(child: Text("NULL"), value: 0),
              for (var emp in bloc.emps.where((e) => e.isWaiter)) DropdownMenuItem(
                child: Text(emp.empLname + ' ' + emp.empFname),
                value: emp.empId
              )
            ],
            onChanged: (newVal) {
              bloc.inEvent.add(AddOrderEmpChoosedEvent(newVal!));
            }
          ),
        ),
        Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            color: Colors.grey[100]
          ),
          height: 200,
          child: ListView(
            controller: ScrollController(),
            children: [
              for (int i = 0; i < bloc.order.listOrders.length; i++) Row(
                children: [
                  Text(bloc.order.listOrders[i].dish.dishName),
                  const Spacer(),
                  Text(bloc.order.listOrders[i].count.toString()),
                  InkWell(
                    child: const Icon(Icons.remove),
                    onTap: () {
                      bloc.inEvent.add(AddOrderRemoveDishEvent(i));
                    }
                  )
                ],
              )
            ],
          )
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextFormField(
              textAlignVertical: TextAlignVertical.top,
              maxLines: null,
              minLines: null,
              expands: true,
              onChanged: (newVal) {
                bloc.inEvent.add(AddOrderCommentEvent(newVal));
              },
              decoration: InputDecoration(
                labelText: l.comment,
                border: const OutlineInputBorder()
              )
            ),
          ),
        ),
        Row(
          children: [
            ElevatedButton(
              child: Text(l.add),
              onPressed: () async {
                if (bloc.order.addable) {
                  // print(jsonEncode(bloc.order.toJson()));
                  await bloc.repo.addOrder(bloc.order);
                  // bloc.inEvent.add(AddOrderLoadEvent());
                  Navigator.pop(context);                  
                }
              },
            ),
            const Spacer(),
            Text(l.summ + ': ' + bloc.order.totalPrice.toString())
          ]
        )
      ]
    );
  }


  Widget buildSecondColumn(AddOrderBloc bloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (int i = 0; i < bloc.dishGroups.length; i++) Row(
                children: [
                  Checkbox(
                    onChanged: (newVal) {
                      bloc.inEvent.add(AddOrderSelectGroupEvent(i));
                    }, 
                    value: bloc.dishGroups[i].selected
                  ),
                  Text(bloc.dishGroups[i].groupName, overflow: TextOverflow.ellipsis,)
                ]
              )
            ]
          )
        ),
        Row(
          children: [
            Expanded(
              flex: 4,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: l.dish_name,
                  border: const OutlineInputBorder()
                ),
                onChanged: (newVal) {
                  bloc.inEvent.add(AddOrderFilterNameEvent(newVal));
                },
              ),
            )
          ],
        ),
        Expanded(
          child: ListView(
            children: [
              for (var dish in bloc.dishes.where((e) => e.dishName.contains(bloc.like) && 
                  // bloc.dishGroups.where((ee) => ee.selected).map<int>((eee) => eee.groupId).contains(e.dishGrId)
                  (bloc.dishGroups.where((ee) => ee.selected).isNotEmpty ? bloc.dishGroups.where((ee) => ee.selected).map<int>((eee) => eee.groupId).contains(e.dishGrId) : true)
                )) ListTile(
                title: Row(
                  children: [
                    // Text(dish.dishId.toString()),
                    Text(dish.dishName, overflow: TextOverflow.ellipsis,),
                    const Spacer(),
                    Text(bloc.dishGroups.firstWhere((e) => e.groupId == dish.dishGrId).groupName, style: TextStyle(color: Colors.grey[600]))
                  ],
                ),
                onTap: () {
                  bloc.inEvent.add(AddOrderAddDishEvent(dish));
                }
              )
            ]
          ),
        )
      ]
    );
  }
}