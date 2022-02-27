import 'package:flutter/material.dart';
import 'package:client/bloc_provider.dart';
import 'package:client/store/add_grocery/add_grocery.dart';
import 'package:client/store/add_supplier/add_supplier.dart';
import 'package:client/store/store_bloc.dart';
import 'package:client/store/store_states_events.dart';
import 'package:provider/provider.dart';

import '../../services/repo.dart';

class ButtonsCard extends StatelessWidget {
  const ButtonsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StoreBloc bloc = BlocProvider.of<StoreBloc>(context);
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: Tooltip(
            message: "+ постачальник",
            child: InkWell(
              child: Container(
                child: const Icon(Icons.delivery_dining, size: 32), 
                margin: const EdgeInsets.all(8),
              ),
              onTap: () async {
                await showDialog(
                  context: context, 
                  builder: (context) {
                    return AddSupplierDialog(repo: Provider.of<Repo>(context));
                  }
                );
                bloc.inEvent.add(StoreLoadEvent());
              }
            ),
          )
        ),
        const SizedBox(height: 5),
        Container(
          alignment: Alignment.center,
          child: Tooltip(
            message: "+ інгредієнт",
            child: InkWell(
              child: Container(
                child: const Icon(Icons.local_grocery_store_outlined, size: 32), 
                margin: const EdgeInsets.all(8),
              ),
              onTap: () async {
                await showDialog(
                  context: context, 
                  builder: (context) {
                    return AddGroceryDialog(repo: Provider.of<Repo>(context));
                  }
                );
                bloc.inEvent.add(StoreLoadEvent());
              }
            ),
          )
        ),
      ],
    );
  }
}