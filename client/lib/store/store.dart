import 'package:client/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:client/store/widgets/groceries_card.dart';
import 'package:provider/provider.dart';

import '../bloc_provider.dart';
import '../main_bloc.dart';
import '../services/repo.dart';

import 'store_bloc.dart';
import 'store_states_events.dart';

import 'widgets/suppliers_card.dart';
import 'widgets/buttons_card.dart';

class StorePage extends StatefulWidget {
  StorePage({Key? key}) : super(key: key);

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<StoreBloc>(
      // bloc: StoreBloc(Provider.of<Repo>(context)),
      blocBuilder: () => StoreBloc(Provider.of<Repo>(context)),
      blocDispose: (StoreBloc bloc) => bloc.dispose(),
      child: Scaffold(
        drawer: NavigationDrawer(),
        appBar: AppBar(
          title: const Center(child: Text("склад || удалять ингредиенты"))
        ),
        body: Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(child: SuppliersCard()),
              const SizedBox(width: 3),
              const ButtonsCard(),
              const SizedBox(width: 3,),
              Expanded(child: GroceriesCard())
            ],
          )
        ),
      )
    );
  }
}
