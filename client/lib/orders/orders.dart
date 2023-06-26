import 'package:client/l10nn/app_localizations.dart';
import 'package:client/orders/orders_states_events.dart';
import 'package:client/orders/widgets/order_container.dart';
import 'package:client/orders/widgets/show_order_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bloc_provider.dart';
import '../services/repo.dart';
import '../widgets/navigation_drawer.dart';
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
      blocBuilder: () => OrdersBloc(Provider.of<Repo>(context, listen: false)),
      blocDispose: (OrdersBloc bloc) => bloc.dispose(),
      child: Builder(
        builder: (context) {
          var bloc = BlocProvider.of<OrdersBloc>(context);
          return StreamBuilder(
            stream: bloc.outState,
            builder: (context, snapshot) {
              var state = snapshot.data;
              if (state is OrdersLoadingState) {
                return Scaffold(appBar: AppBar(leading: const BackButton()), body: const Center(child: CircularProgressIndicator()));
              } else if (state is OrdersLoadedState) {
                return Scaffold(
                  key: key,
                  drawer: const MyNavigationDrawer(),
                  appBar: AppBar(
                    title: Center(child: Text(l.orders)),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () async {
                          await Navigator.push(context, MaterialPageRoute(builder: (context) => AddOrderPage(dishes: bloc.dishes, dishGroups: bloc.groups,)));
                          bloc.inEvent.add(OrdersLoadEvent());
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
                            bloc.inEvent.add(OrdersReloadEvent());
                          }, 
                          onPay: () async {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return PayOrderDialog(order: bloc.orders[i]);
                              }
                            );
                            bloc.inEvent.add(OrdersReloadEvent());
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