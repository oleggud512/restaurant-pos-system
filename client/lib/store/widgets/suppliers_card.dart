import 'package:flutter/material.dart';

import 'package:client/bloc_provider.dart';
import 'package:client/store/store_bloc.dart';
import 'package:client/store/store_states_events.dart';

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
    StoreBloc bloc = BlocProvider.of<StoreBloc>(context);
    // print(bloc);
    return Card(
      elevation: 2.0,
      child: StreamBuilder(
        stream: bloc.outState,
        builder: (context, snapshot) {
          var state = snapshot.data;
          if (state is StoreLoadingState) {
            return const Center(child: CircularProgressIndicator(),);
          } else if (state is StoreLoadedState || state is StoreGroceriesLoadingState) {
            var sup = bloc.suppliers;
            return ListView.builder(
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
                    bloc.inEvent.add(StoreLoadEvent());
                  },
                );
              }
            );
          }
          return const Center(child: Text("something went wrong"));
        }
      ),
    );
  }
}