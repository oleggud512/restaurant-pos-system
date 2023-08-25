import 'package:flutter/material.dart';

import 'package:client/utils/bloc_provider.dart';
import 'package:client/features/store/store_bloc.dart';
import 'package:client/features/store/store_states_events.dart';

import '../suppliers/sup.dart';

class SuppliersCard extends StatefulWidget {
  const SuppliersCard({Key? key}) : super(key: key);

  @override
  State<SuppliersCard> createState() => _SuppliersCardState();
}

class _SuppliersCardState extends State<SuppliersCard> {
  var supScroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: BlocBuilder<StoreBloc, StoreState>(
        builder: (context, state) {
          final bloc = context.readBloc<StoreBloc>();
          final sup = bloc.suppliers;
          return switch (state) {
            StoreLoadedState() || StoreGroceriesLoadingState() => ListView.builder(
              controller: supScroll,
              itemCount: sup.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(sup[index].supplierName),
                  subtitle: Text(sup[index].contacts ?? "..."),
                  onTap: () async {
                    // bloc.inEvent.add(StoreReloadGroceriesEvent());
                    await showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return SupplierDetailsDialog(id: sup[index].supplierId, groceries: bloc.groceries);
                      }
                    );
                    bloc.add(StoreLoadEvent());
                  },
                );
              }
            ),
            StoreLoadingState() => const Center(child: CircularProgressIndicator(),),
            _ => const Center(child: Text("something went wrong"))
          };
        }
      ),
    );
  }
}