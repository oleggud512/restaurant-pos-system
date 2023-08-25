import 'package:client/features/store/store_states_events.dart';
import 'package:client/l10n/app_localizations.g.dart';
import 'package:flutter/material.dart';
import 'package:client/features/store/widgets/groceries_card.dart';
import 'package:provider/provider.dart';

import '../../utils/bloc_provider.dart';
import '../../services/repo.dart';

import '../home/toggle_drawer_button.dart';
import 'store_bloc.dart';

import 'widgets/suppliers_card.dart';
import 'widgets/buttons_card.dart';

class StorePage extends StatefulWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<StoreBloc>(
      create: (_) => StoreBloc(Provider.of<Repo>(context))..add(StoreLoadEvent()),
      child: Scaffold(
        appBar: AppBar(
          leading: const ToggleDrawerButton(),
          title: Center(child: Text(AppLocalizations.of(context)!.store))
        ),
        body: Container(
          padding: const EdgeInsets.all(8),
          child: const Row(
            children: [
              Expanded(child: SuppliersCard()),
              SizedBox(width: 3),
              ButtonsCard(),
              SizedBox(width: 3,),
              Expanded(child: GroceriesCard())
            ],
          )
        ),
      )
    );
  }
}
