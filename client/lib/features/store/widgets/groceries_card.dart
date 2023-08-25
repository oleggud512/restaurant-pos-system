import 'package:client/l10n/localizations_context_ext.dart';
import 'package:client/services/models.dart';
import 'package:flutter/material.dart';

import 'package:client/features/store/groceries/grocery.dart';
import 'package:client/features/store/store_states_events.dart';

import '../../../utils/bloc_provider.dart';
import 'package:client/features/store/store_bloc.dart';

class GroceriesCard extends StatefulWidget {
  const GroceriesCard({Key? key}) : super(key: key);

  @override
  State<GroceriesCard> createState() => _GroceriesCardState();
}

class _GroceriesCardState extends State<GroceriesCard> {
  var grocScroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    var l = context.ll!;
    final bloc = context.readBloc<StoreBloc>();
    return Card(
      elevation: 3.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField( 
                  onChanged: (newVal) {
                    bloc.add(StoreReloadGroceriesEvent(like: newVal));
                  }
                ),
              ),
              FloatingActionButton(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                child: (bloc.grocSortNow == Sorting.asc) ? const Icon(Icons.south_rounded) : const Icon(Icons.north_rounded),
                onPressed: () {
                  setState(() {
                    bloc.grocSortNow = (bloc.grocSortNow == Sorting.asc) ? Sorting.desc : Sorting.asc;
                  });
                  bloc.add(StoreSortGrocEvent(bloc.grocSortNow));
                }
              ),
              const SizedBox(width: 10)
            ],
          ),
          BlocBuilder<StoreBloc, StoreState>(
            builder: (BuildContext context, state) {
              if (state is StoreGroceriesLoadingState || state is StoreLoadingState) {
                // print("state is StoreGroceriesLoadingState or  StoreLoadEvent");
                return const Expanded(child: Center(child: CircularProgressIndicator()));
              } else if (state is StoreLoadedState) {
                return Expanded(
                  child: ListView.builder(
                    controller: grocScroll,
                    itemCount: state.groceries.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(state.groceries[index].grocName),
                        subtitle: Text('${state.groceries[index].avaCount} (${l.measure_short(state.groceries[index].grocMeasure)})'),
                        onTap: () async {
                          // диалог из которого мы можем изменить имя, грам/литр и количество
                          await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return GroceryDialog(id: state.groceries[index].grocId);
                            }
                          );
                          bloc.add(StoreLoadEvent());
                        },
                      );
                    }
                  ),
                );
              }
              return Container();
            }
          )
        ]
      )
    );
  }
}