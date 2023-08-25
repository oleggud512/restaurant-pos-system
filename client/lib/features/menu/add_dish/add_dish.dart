import 'package:client/l10n/app_localizations.g.dart';
import 'package:client/features/menu/add_dish/prime_cost_details/prime_cost_details_dialog.dart';
import 'package:client/features/menu/widgets/text_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../utils/bloc_provider.dart';
import '../../../services/models.dart';
import '../../../services/repo.dart';
import '../widgets/photo.dart';
import 'add_dish_bloc.dart';
import 'add_dish_states_events.dart';
import '../widgets/group_picker.dart';


class AddDishPage extends StatefulWidget {
  const AddDishPage({Key? key, required this.groups}) : super(key: key);

  final List<DishGroup> groups;

  @override
  State<AddDishPage> createState() => _AddDishPageState();
}

class _AddDishPageState extends State<AddDishPage> {
  late AppLocalizations l;
  @override
  Widget build(BuildContext context) {
    l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider<AddDishBloc>(
        create: (_) => AddDishBloc(Provider.of<Repo>(context), widget.groups)
          ..add(AddDishLoadEvent()),
        child: BlocBuilder<AddDishBloc, AddDishState>(
          builder: (context, state) {
            final bloc = context.readBloc<AddDishBloc>();
            if (state is AddDishLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AddDishLoadedState) {
              // return buildTempContent(bloc, state);
              return buildLayout(bloc, state);
            } return Container();
          }
        ),
      )
    );
  }

  Widget buildLayout(AddDishBloc bloc, AddDishLoadedState state) {
    return Row(
      children: [
        Expanded(
          child: buildFirstColumn(bloc, state)
          // child: Container(color: Colors.red)
        ),
        const SizedBox(width: 10),
        Expanded(
          child: buildSecondColumn(bloc, state)
          // child: Container(color: Colors.red)
        ),
        const SizedBox(width: 10),
        Expanded(
          child: buildThirdColumn(bloc, state)
          // child: Container(color: Colors.red)
        ),
      ]
    );
  }

  Widget buildFirstColumn(AddDishBloc bloc, AddDishLoadedState state) {
    return ListView(
      controller: ScrollController(),
      children: [
        Photo(dish: bloc.dish, edit: true),
        TextFormField(
          decoration: InputDecoration(
            labelText: l.dish_name,
          ),
          onChanged: (String newVal) {
            bloc.add(AddDishNameChangedEvent(newVal));
          }
        ),
        TextFormField(
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
          ],
          decoration: InputDecoration(
            labelText: l.price,
          ),
          onChanged: (String newVal) {
            bloc.add(AddDishPriceChangedEvent(newVal));
          }
        ),
        Row(
          children: [
            Expanded(child: Text("${l.prime_cost}: ")),
            Expanded(
              child: StreamBuilder(
                stream: bloc.outPrimeCost,
                builder: (context, snapshot) {
                  var state = snapshot.data;
                  if (state is AddDishPrimeCostLoadingState) {
                    return const Center(child: CircularProgressIndicator(),);
                  } else if (state is AddDishPrimeCostLoadedState) {
                    return Center(child: InkWell(
                      child: Text('${bloc.primeCost['total']}'),
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            // return PrimeCostDetailsDialog(data: bloc.primeCost);
                            return PrimeCostDetailsDialog(dish: bloc.dish);
                          }
                        );
                      }
                    ),);
                  }
                  return Container();
                }
              ),
            ),
          ],
        ),
        GroupPicker(
          value: bloc.dish.dishGrId, 
          groups: bloc.dishGroups, 
          onChanged: (newVal) {
            bloc.add(AddDishGroupChanged(newVal!));
          },
        ),
      ]
    );
  }

  Widget buildSecondColumn(AddDishBloc bloc, AddDishLoadedState state) {
    return ListView(
      children: [
        for (int i = 0; i < bloc.dish.dishGrocs.length; i++) Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(5.0))
              ),
              height: 20,
              width: 20,
              child: InkWell(
                onTap: () {
                  bloc.add(AddDishRemoveGrocEvent(i));
                },
                child: const Icon(Icons.close, size: 15)
              ),
            ),
            Expanded(
              flex: 4,
              child: Center(child: Text(bloc.dish.dishGrocs[i].grocName))
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,3}'))
                  ],
                  decoration: InputDecoration(
                    labelText: l.measure_short('gram'),
                  ),
                  onChanged: (newVal) {
                    bloc.add(AddDishDishGrocCountChangedEvent(bloc.dish.dishGrocs[i].grocId, newVal));
                  },
                ),
              )
            )
          ],
        )
      ],
    );
  }

  Widget buildThirdColumn(AddDishBloc bloc, AddDishLoadedState state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: l.name,
              border: const OutlineInputBorder()
            ),
            onChanged: (newVal) {
              bloc.add(AddDishFindGrocEvent(newVal)); // поиск / фильтрация
            }
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int i = 0; i < state.groceries.length; i++) InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    child: Text(state.groceries[i].grocName)
                  ),
                  onTap: () {
                    bloc.add(AddDishAddGrocEvent(state.groceries[i]));
                  }
                )
              ],
            )
          ),
        ),
        ListTile(
          title: ElevatedButton(
            onPressed: () async {
              if (bloc.dish.isSaveable) {
                await Provider.of<Repo>(context, listen: false).addDish(bloc.dish);
                Navigator.pop(context);
              }
            }, 
            child: Text(l.add)
          ),
        ), 
        Expanded(child: TextEditor(
          text: bloc.dish.dishDescr, 
          isEdit: true, 
          onChanged: (newVal) => bloc.dish.dishDescr = newVal,
        ))
      ],
    );
  }

}
