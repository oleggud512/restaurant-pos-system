import 'package:client/features/menu/menu_states_events.dart';
import 'package:client/l10n/localizations_context_ext.dart';
import 'package:client/utils/bloc_provider.dart';
import 'package:client/utils/extensions/string.dart';
import 'package:client/utils/logger.dart';
import 'package:client/utils/number_range_picker.dart';
import 'package:client/utils/sizes.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_treeview/flutter_treeview.dart';

import '../../../l10n/app_localizations.g.dart';
import '../../supplys/filter_sort_drawer/filter_sort_drawer.dart';
import '../menu_bloc.dart';


class FilterSortMenuDrawer extends StatefulWidget {
  const FilterSortMenuDrawer({Key? key}) : super(key: key);

  @override
  State<FilterSortMenuDrawer> createState() => _FilterSortMenuDrawerState();
}

class _FilterSortMenuDrawerState extends State<FilterSortMenuDrawer> with TickerProviderStateMixin {
  late AppLocalizations l;
  
  @override
  Widget build(BuildContext context) {
    l = context.ll!;
    final bloc = context.readBloc<MenuBloc>();
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              controller: ScrollController(),
              children: [
                ListTile(title: Text(l.sorting, style: Theme.of(context).textTheme.titleMedium)),
                ListTile(  // выбор того по чем сортируем
                  leading: Radio<String>(
                    value: 'dish_name',
                    groupValue: bloc.fsMenu!.sortColumn,
                    onChanged: (newVal) {
                      setState(() {
                        bloc.fsMenu!.sortColumn = newVal!;
                      });
                    }
                  ),
                  title: Text('${l.by} ${l.name}')
                ),
                ListTile(  // выбор того по чем сортируем
                  leading: Radio<String>(
                    value: 'dish_price',
                    groupValue: bloc.fsMenu!.sortColumn,
                    onChanged: (newVal) {
                      setState(() {
                        bloc.fsMenu!.sortColumn = newVal!;
                      });
                    }
                  ),
                  title: Text("${l.by} ${l.price.toLowerCase()}")
                ),
                ListTile(title: AscDescDropdown(  // выбор направления
                  value: bloc.fsMenu!.asc,
                  onChanged: (newVal) {
                    setState(() {
                      bloc.fsMenu!.asc =  newVal!;
                    });
                  }
                )),
                ListTile(title: Text(l.filtering, style: Theme.of(context).textTheme.titleMedium)), 
                ListTile(           // поиск по названию (работает сразу)
                  title: TextFormField(
                    // controller: TextEditingController(text: bloc.fsMenu!.like),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: l.dish_name
                    ),
                    onChanged: (newVal) {
                      bloc.add(MenuFilterDishNameEvent(newVal));
                    },
                  )
                ),
                ListTile(title: Row(              // цена от до
                  children: [
                    Text("${l.price}: "),
                    Expanded(child: TextFormField( // вынести в отдельный класс с стилями нужными
                      textAlign: TextAlign.center,
                      controller: TextEditingController(text: bloc.fsMenu!.priceFrom.toString()),
                      onChanged: (newVal) {
                        // bloc.add(SupplyFromPriceChangedEvent(newVal));
                        bloc.fsMenu!.priceFrom = double.parse(newVal.isEmpty ? '0.0' : newVal);
                      }
                    )),
                    const Text("-"),
                    Expanded(child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: TextEditingController(text: bloc.fsMenu!.priceTo.toString()),
                      onChanged: (newVal) {
                        // bloc.add(SupplyToPriceChangedEvent(newVal));
                        bloc.fsMenu!.priceTo = double.parse(newVal.isEmpty ? '0.0' : newVal);
                      },
                    )),
                  ],
                )),
                NumberRangePicker(
                  min: 100,
                  max: 7000,
                  label: 'Price'.hc,
                  toLabel: 'To'.hc,
                  fromLabel: 'From'.hc,
                  initial: const RangeValues(0.3, 0.8),
                  onChanged: (start, end) {
                    glogger.i('$start - $end');
                  }
                ),
                ListTile(
                  title: InkWell(
                    onTap: () { 
                      setState(() {
                        bloc.showGrocList = !bloc.showGrocList;
                      });
                    },
                    child: Row(
                      children: [
                        Text(l.grocery(2)),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(10), 
                          child: Center(
                            child: (!bloc.showGrocList) ? const Icon(Icons.arrow_drop_down) : const RotatedBox(
                              quarterTurns: 2,
                              child: Icon(Icons.arrow_drop_down)
                            )
                          )
                        )
                      ]
                    ),
                  )
                ),
                Visibility(
                  visible: bloc.showGrocList,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (int i = 0; i < bloc.groceries.length; i++) ListTile(
                        title: Text(bloc.groceries[i].grocName),
                        leading: Checkbox(
                          value: bloc.groceries[i].selected,
                          onChanged: (newVal) {
                            bloc.add(MenuFiterGroceriesChangedEvent(i));
                          }
                        )
                      )
                    ],
                  )
                ),
                ListTile(
                  title: InkWell(
                    onTap: () { 
                      setState(() {
                        bloc.showGroupList = !bloc.showGroupList;
                      });
                    },
                    child: Row(
                      children: [
                        Text(l.groups),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(10), 
                          child: Center(
                            child: (!bloc.showGroupList) ? const Icon(Icons.arrow_drop_down) : const RotatedBox(
                              quarterTurns: 2, 
                              child: Icon(Icons.arrow_drop_down)
                            )
                          )
                        )
                      ]
                    ),
                  )
                ),
                Visibility(
                  visible: bloc.showGroupList,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final group in bloc.groups!) ListTile(
                        title: Text(group.groupName),
                        leading: Checkbox(
                          value: bloc.fsMenu!.groups.contains(group),
                          onChanged: (newVal) {
                            bloc.add(MenuToggleFilterDishGroupEvent(group));
                          }
                        )
                      )
                    ],
                  )
                ),
              ]
            ),
          ),
          
          Expanded(
            flex: 0,
            child: BottomAppBar(
              height: p56,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  bloc.add(MenuLoadEvent());
                },
                child: Text(l.find)
              ),
            )
          )
        ]
      )
    );
  }
}
