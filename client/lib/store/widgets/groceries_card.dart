import 'package:client/services/models.dart';
import 'package:flutter/material.dart';

import 'package:client/store/groceries/grocery.dart';
import 'package:client/store/store_states_events.dart';

import '../../bloc_provider.dart';
import 'package:client/store/store_bloc.dart';
import '../../l10nn/app_localizations.dart';
import 'my_text_field.dart';

class GroceriesCard extends StatefulWidget {
  const GroceriesCard({Key? key}) : super(key: key);

  @override
  State<GroceriesCard> createState() => _GroceriesCardState();
}

class _GroceriesCardState extends State<GroceriesCard> {
  var grocScroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    var l = AppLocalizations.of(context)!;
    StoreBloc bloc = BlocProvider.of<StoreBloc>(context);
    return Card(
      elevation: 3.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: MyTextField( 
                  onChanged: (newVal) {
                    bloc.inEvent.add(StoreReloadGroceriesEvent(like: newVal));
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
                  bloc.inEvent.add(StoreSortGrocEvent(bloc.grocSortNow));
                }
              ),
              const SizedBox(width: 10)
            ],
          ),
          StreamBuilder(
            stream: bloc.outState,
            builder: (BuildContext context, AsyncSnapshot<StoreState> snapshot) {
              var state = snapshot.data;
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
                        subtitle: Text(state.groceries[index].avaCount.toString() + 
                          ' (${l.measure_short(state.groceries[index].grocMeasure)})'),
                        onTap: () async {
                          // диалог из которого мы можем изменить имя, грам/литр и количество
                          await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return GroceryDialog(id: state.groceries[index].grocId);
                            }
                          );
                          bloc.inEvent.add(StoreLoadEvent());
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