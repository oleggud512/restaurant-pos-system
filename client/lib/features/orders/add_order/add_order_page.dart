
import 'package:client/l10n/app_localizations.g.dart';
import 'package:client/features/orders/add_order/add_order_events.dart';
import 'package:client/services/entities/dish.dart';
import 'package:client/services/entities/dish_group.dart';
import 'package:client/utils/extensions/string.dart';
import 'package:client/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/bloc_provider.dart';
import '../../../services/repo.dart';
import 'add_order_bloc.dart';
import 'add_order_state.dart';


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
        builder: (context, state) {
          final bloc = context.readBloc<AddOrderBloc>();

          if (state.isLoading) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text('Add new order'.hc)
            ),
            body: Padding(
              padding: const EdgeInsets.all(p16),
              child: Row(
                children: [
                  Expanded(child: buildFirstColumn(context, bloc, state)),
                  w16gap,
                  Expanded(child: buildSecondColumn(context, bloc, state)),
                ],
              ),
            )
          );
        },
      )
    );
  }

  final cont1 = ScrollController();

  Widget buildFirstColumn(BuildContext context, AddOrderBloc bloc, AddOrderState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButton<int>(
          isExpanded: true,
          value: state.order.empId,
          items: [
            DropdownMenuItem(value: null, child: Text("[no waiter selected]".hc)),
            for (var emp in state.employees.where((e) => e.isWaiter)) DropdownMenuItem(
              value: emp.empId,
              child: Text('${emp.empLname} ${emp.empFname}'),
            )
          ],
          onChanged: (newVal) {
            bloc.add(AddOrderEmployeeSelectedEvent(newVal!));
          }
        ),
        h8gap,
        // ORDER LIST
        Text('Order list'.hc,
          style: Theme.of(context).textTheme.titleLarge
        ),
        Expanded(
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.all(p16),
              child: ListView(
                children: [
                  for (int i = 0; i < state.order.listOrders.length; i++) Row(
                    children: [
                      Text(state.order.listOrders[i].dish.dishName,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Spacer(),
                      Text(state.order.listOrders[i].count.toString(),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      InkWell(
                        child: const Icon(Icons.remove),
                        onTap: () {
                          bloc.add(AddOrderRemoveDishEvent(i));
                        }
                      )
                    ],
                  )
                ]
              )
            )
          )
        ),
        h8gap,
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: p184
          ),
          child: TextFormField(
            scrollController: cont1,
            textAlignVertical: TextAlignVertical.top,
            maxLines: null,
            minLines: null,
            onChanged: (newVal) {
              bloc.add(AddOrderCommentChangedEvent(newVal));
            },
            decoration: InputDecoration(
              labelText: l.comment,
              border: const OutlineInputBorder()
            )
          ),
        ),
        h8gap,
        Row(
          children: [
            FilledButton(
              child: Text(l.add),
              onPressed: () async {
                if (state.order.canAddOrder) {
                  // print(jsonEncode(bloc.order.toJson()));
                  await bloc.repo.addOrder(state.order);
                  // bloc.add(AddOrderLoadEvent());
                  if (mounted) Navigator.pop(context);
                }
                bloc.add(AddOrderSubmitEvent(onSuccess: () {
                  if (mounted) Navigator.pop(context);
                }));
              },
            ),
            const Spacer(),
            Text('${l.summ}: ${state.order.totalPrice}')
          ]
        )
      ]
    );
  }


  Widget buildSecondColumn(BuildContext context, AddOrderBloc bloc, AddOrderState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final group in state.dishGroups) Row(
                children: [
                  Checkbox(
                    onChanged: (newVal) {
                      bloc.add(AddOrderGroupSelectedChangedEvent(group));
                    },
                    value: state.isDishGroupSelected(group)
                  ),
                  Text(group.groupName,
                    overflow: TextOverflow.ellipsis,
                  )
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
                  bloc.add(AddOrderDishFilterChangedEvent(newVal));
                },
              ),
            )
          ],
        ),
        Expanded(
          child: ListView(
            children: [
              for (final dish in state.filteredDishes) ListTile(
                title: Row(
                  children: [
                    Text(dish.dishName, overflow: TextOverflow.ellipsis,),
                    const Spacer(),
                    Text(state.dishGroups.firstWhere((e) => e.groupId == dish.dishGrId).groupName,
                      style: TextStyle(color: Colors.grey[600])
                    )
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