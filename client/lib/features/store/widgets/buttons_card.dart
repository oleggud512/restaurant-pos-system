import 'package:client/l10n/localizations_context_ext.dart';
import 'package:client/utils/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:client/features/store/add_grocery/add_grocery.dart';
import 'package:client/features/store/add_supplier/add_supplier.dart';
import 'package:client/features/store/store_bloc.dart';
import 'package:client/features/store/store_states_events.dart';
import 'package:provider/provider.dart';

import '../../../services/repo.dart';

class ButtonsCard extends StatelessWidget {
  const ButtonsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l = context.ll!;
    final bloc = context.readBloc<StoreBloc>();
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: Tooltip(
            message: "+ ${l.supplier('1')}",
            child: InkWell(
              child: Container(
                margin: const EdgeInsets.all(8),
                child: const Icon(Icons.delivery_dining, size: 32), 
              ),
              onTap: () async {
                await showDialog(
                  context: context, 
                  builder: (context) {
                    return AddSupplierDialog(repo: Provider.of<Repo>(context));
                  }
                );
                bloc.add(StoreLoadEvent());
              }
            ),
          )
        ),
        const SizedBox(height: 5),
        Container(
          alignment: Alignment.center,
          child: Tooltip(
            message: "+ ${l.grocery(1)}",
            child: InkWell(
              child: Container(
                margin: const EdgeInsets.all(8),
                child: const Icon(Icons.local_grocery_store_outlined, size: 32), 
              ),
              onTap: () async {
                await showDialog(
                  context: context, 
                  builder: (context) {
                    return AddGroceryDialog(repo: Provider.of<Repo>(context));
                  }
                );
                bloc.add(StoreLoadEvent());
              }
            ),
          )
        ),
      ],
    );
  }
}