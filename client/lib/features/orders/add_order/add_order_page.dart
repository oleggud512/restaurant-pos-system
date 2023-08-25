
import 'package:client/l10n/app_localizations.g.dart';
import 'package:client/features/orders/add_order/add_order_states_events.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/bloc_provider.dart';
import '../../../services/models.dart';
import '../../../services/repo.dart';
import 'add_order_bloc.dart';


class AddOrderPage extends StatefulWidget {
  const AddOrderPage({Key? key, required this.dishes, required this.dishGroups}) : super(key: key);

  final List<Dish> dishes;
  final List<DishGroup> dishGroups;

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  late AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    l = AppLocalizations.of(context)!;
    return BlocProvider<AddOrderBloc>(
      create: (_) => AddOrderBloc(
        Provider.of<Repo>(context, listen: false), 
        widget.dishes, 
        widget.dishGroups
      )..add(AddOrderLoadEvent()),
      child: BlocBuilder<AddOrderBloc, AddOrderState>(
        builder: (BuildContext context, state) {
          final bloc = context.readBloc<AddOrderBloc>();
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
              const DropdownMenuItem(value: 0, child: Text("NULL")),
              for (var emp in bloc.emps.where((e) => e.isWaiter)) DropdownMenuItem(
                value: emp.empId,
                child: Text('${emp.empLname} ${emp.empFname}'),
              )
            ],
            onChanged: (newVal) {
              bloc.add(AddOrderEmpChoosedEvent(newVal!));
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
                      bloc.add(AddOrderRemoveDishEvent(i));
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
                bloc.add(AddOrderCommentEvent(newVal));
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
                  // bloc.add(AddOrderLoadEvent());
                  if (mounted) Navigator.pop(context);                  
                }
              },
            ),
            const Spacer(),
            Text('${l.summ}: ${bloc.order.totalPrice}')
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
                      bloc.add(AddOrderSelectGroupEvent(i));
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
                  bloc.add(AddOrderFilterNameEvent(newVal));
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
                  bloc.add(AddOrderAddDishEvent(dish));
                }
              )
            ]
          ),
        )
      ]
    );
  }
}