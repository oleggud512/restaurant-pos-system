import 'package:client/features/orders/checkout/checkout_dialog.dart';
import 'package:client/l10n/app_localizations.g.dart';
import 'package:client/features/orders/orders_states_events.dart';
import 'package:client/features/orders/widgets/order_container.dart';
import 'package:client/features/orders/widgets/show_order_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/bloc_provider.dart';
import '../../services/repo.dart';
import '../../utils/sizes.dart';
import '../home/toggle_drawer_button.dart';
import 'add_order/add_order_page.dart';
import 'orders_bloc.dart';


class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var ll = AppLocalizations.of(context)!;
    return BlocProvider<OrdersBloc>(
      create: (_) => OrdersBloc(Provider.of<Repo>(context, listen: false))
        ..add(OrdersLoadEvent()),
      child: Builder(
        builder: (context) {
          return BlocBuilder<OrdersBloc, OrdersState>(
            builder: (context, state) {
              final bloc = context.readBloc<OrdersBloc>();
              return switch (state) {
                OrdersLoadingState() => Scaffold(
                  appBar: AppBar(leading: const ToggleDrawerButton(),),
                  body: const Center(child: CircularProgressIndicator(),),
                ),
                OrdersLoadedState() => Scaffold(
                  key: key,
                  appBar: AppBar(
                    leading: const ToggleDrawerButton(),
                    title: Center(child: Text(ll.orders)),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () async {
                          await Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>
                                  AddOrderPage(dishes: bloc.dishes,
                                    dishGroups: bloc.groups,)));
                          bloc.add(OrdersLoadEvent());
                        }
                      )
                    ],
                  ),
                  body: bloc.orders.isNotEmpty
                    ? ListView(
                    padding: const EdgeInsets.symmetric(horizontal: p8),
                    children: [
                      for (final order in bloc.orders) OrderContainer(
                        order: order,
                        onTap: () async {
                          await OrderDialog(order: order).show(context);
                        },
                        onDelete: () async {
                          // TODO: (2) move to bloc
                          await bloc.repo.deleteOrder(order.ordId!);
                          bloc.add(OrdersReloadEvent());
                        },
                        onCheckout: () async {
                          await CheckoutDialog(order: order).show(context);
                          bloc.add(OrdersReloadEvent());
                        }
                      ),
                    ],
                  )
                  : Center(
                    child: Text(ll.no_orders_placeholder,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.grey),
                      textAlign: TextAlign.center,
                    )
                  )
                ),
                _ => const Material()
              };
            }
          );
        },
      )
    );
  }
}