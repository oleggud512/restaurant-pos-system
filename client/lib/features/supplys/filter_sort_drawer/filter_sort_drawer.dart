import 'package:client/l10n/app_localizations.g.dart';
import 'package:client/features/supplys/supplys_states_events.dart';
import 'package:flutter/material.dart';

import '../../../utils/bloc_provider.dart';
import '../supplys_bloc.dart';

class SortFilterDrawer extends StatefulWidget {
  const SortFilterDrawer({Key? key}) : super(key: key);



  @override
  State<SortFilterDrawer> createState() => _SortFilterDrawerState();
}

class _SortFilterDrawerState extends State<SortFilterDrawer> {
  late AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<SupplysBloc>(context);

    var fromCont = TextEditingController(text: bloc.fsd?.fPriceFrom.toString());
    var toCont = TextEditingController(text: bloc.fsd?.fPriceTo.toString());
    l = AppLocalizations.of(context)!;
    return Drawer(
      child: ListView(
        controller: ScrollController(), // ScrollController is currently attached to more than one ScrollPosition.
        children: [
          ListTile(title: Text(l.sorting)),
          ListTile(  // выбор того по чем сортируем
            leading: Radio<String>(
              value: "summ",
              groupValue: bloc.fsd?.sortCollumn,
              onChanged: (newVal) {
                bloc.add(SupplySortCollumnChangedEvent(newVal!));
              }
            ),
            title: Text("${l.by} ${l.price.toLowerCase()}")
          ),
          ListTile(  // выбор того по чем сортируем
            leading: Radio<String>(
              value: "supply_date",
              groupValue: bloc.fsd?.sortCollumn,
              onChanged: (newVal) {
                bloc.add(SupplySortCollumnChangedEvent(newVal!));
              }
            ),
            title: Text("${l.by} ${l.date.toLowerCase()}")
          ),
          ListTile(title: AscDescDropdown(
            value: bloc.fsd?.sortDirection,
            onChanged: (newVal) {
              bloc.add(SupplySortDirectionChangedEvent(newVal!));
            },
          )), // выбор направления
          ListTile(title: Text(l.filtering)), 
          ListTile(title: Row( // цена от до
            children: [
              Text("${l.price}: "),
              Expanded(child: TextFormField( // вынести в отдельный класс с стилями нужными
                controller: fromCont,
                textAlign: TextAlign.center,
                onChanged: (newVal) {
                  bloc.add(SupplyFromPriceChangedEvent(newVal));
                }
              )),
              const Text("-"),
              Expanded(child: TextFormField(
                controller: toCont,
                textAlign: TextAlign.center,
                onChanged: (newVal) {
                  bloc.add(SupplyToPriceChangedEvent(newVal));
                }
              )),
            ],
          )),
          ListTile(title: Row( // дата от до
            children: [
              Text("${l.date}: "),
              Expanded(child: TextButton(
                child: Text(bloc.fsd!.fDateFrom.toString().substring(0, 10)),
                onPressed: () async {
                  DateTime dateFrom = await showDialog(
                    context: context,
                    builder: (context) {
                      return DatePickerDialog(
                        initialDate: bloc.fsd!.fDateFrom, 
                        firstDate: bloc.fsd!.minDate, 
                        lastDate: bloc.fsd!.maxDate
                      );
                    }
                  );
                  bloc.add(SupplyFromDateChangedEvent(dateFrom));
                },
              )),
              const Text("-"),
              Expanded(child: TextButton(
                child: Text(bloc.fsd!.fDateTo.toString().substring(0, 10)),
                onPressed: () async {
                  DateTime dateTo = await showDialog(
                    context: context,
                    builder: (context) {
                      return DatePickerDialog(
                        initialDate: bloc.fsd!.fDateTo, 
                        firstDate: bloc.fsd!.minDate, 
                        lastDate: bloc.fsd!.maxDate
                      );
                    }
                  );
                  bloc.add(SupplyToDateChangedEvent(dateTo));
                },
              )),
            ],
          )),
          DataTable( // какие поставщики
            columns: [
              DataColumn(label: Text(l.supplier('2'), style: const TextStyle(fontWeight: FontWeight.bold)))
            ],
            rows: [
              for (int i = 0; i < bloc.fsd!.suppliers.length; i++) DataRow(
                selected: bloc.fsd!.suppliers[i].selected,
                cells: [
                  DataCell(Text(bloc.fsd!.suppliers[i].supplierName))
                ],
                onSelectChanged: (newVal) {
                  setState(() {
                    bloc.fsd!.suppliers[i].selected = newVal!;
                  });
                }
              )
            ]
          ),
          ListTile(
            title: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                bloc.add(SupplyLoadEvent());
              }, 
              child: Text(l.find)
            ),
          ),
        ]
      )
    );
  }
}


class AscDescDropdown extends StatefulWidget {
  const AscDescDropdown({Key? key, required this.value, required this.onChanged}) : super(key: key);
  
  final String? value;
  final void Function(String?)? onChanged;

  @override
  State<AscDescDropdown> createState() => _AscDescDropdownState();
}

class _AscDescDropdownState extends State<AscDescDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: widget.value,
      isExpanded: true,
      items: [
        DropdownMenuItem(value: "asc", child: Text(AppLocalizations.of(context)!.asc('asc'))),
        DropdownMenuItem(value: "desc", child: Text(AppLocalizations.of(context)!.asc('desc')))
      ],
      onChanged: widget.onChanged
    );
  }
}