import 'package:client/l10n/app_localizations.g.dart';
import 'package:client/features/orders/orders_states_events.dart';
import 'package:client/features/orders/widgets/order_container.dart';
import 'package:client/features/orders/widgets/show_order_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/bloc_provider.dart';
import '../../services/repo.dart';
import '../home/toggle_drawer_button.dart';
import 'add_order/add_order_page.dart';
import 'orders_bloc.dart';
import 'widgets/pay_order_dialog.dart';


class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var l = AppLocalizations.of(context)!;
    return BlocProvider<OrdersBloc>(
      create: (_) => OrdersBloc(Provider.of<Repo>(context, listen: false))..add(OrdersLoadEvent()),
      child: Builder(
        builder: (context) {
          return BlocBuilder<OrdersBloc, OrdersState>(
            builder: (context, state) {
              final bloc = context.readBloc<OrdersBloc>();
              if (state is OrdersLoadingState) {
                return Scaffold(appBar: AppBar(leading: const ToggleDrawerButton(),), body: const Center(child: CircularProgressIndicator()));
              } else if (state is OrdersLoadedState) {
                return Scaffold(
                  key: key,
                  appBar: AppBar(
                    leading: const ToggleDrawerButton(),
                    title: Center(child: Text(l.orders)),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () async {
                          await Navigator.push(context, MaterialPageRoute(builder: (context) => AddOrderPage(dishes: bloc.dishes, dishGroups: bloc.groups,)));
                          bloc.add(OrdersLoadEvent());
                        }
                      )
                    ],
                  ),
                  body: bloc.orders.isNotEmpty ? 
                    ListView(
                      children: [
                        for (int i = 0; i < bloc.orders.length; i++) OrderContainer(
                          order: bloc.orders[i],
                          onTap: () async {
                            // show.........something...
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return OrderDialog(order: bloc.orders[i]);
                              }
                            );
                          },
                          onDelete: () async {
                            await bloc.repo.deleteOrder(bloc.orders[i].ordId!);
                            bloc.add(OrdersReloadEvent());
                          }, 
                          onPay: () async {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return PayOrderDialog(order: bloc.orders[i]);
                              }
                            );
                            bloc.add(OrdersReloadEvent());
                          }
                        )
                      ],
                    )
                  : const Center(child: Text("empty", style: TextStyle(height: 100)))
                );
              } 
              return Container();
            }
          );
        },
      )
    );
  }
}