import 'package:client/supplys/supplys_states_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../bloc_provider.dart';
import '../supplys_bloc.dart';

class SortFilterDrawer extends StatefulWidget {
  SortFilterDrawer({Key? key}) : super(key: key);



  @override
  State<SortFilterDrawer> createState() => _SortFilterDrawerState();
}

class _SortFilterDrawerState extends State<SortFilterDrawer> {

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<SupplysBloc>(context);

    var fromCont = TextEditingController(text: bloc.fsd?.fPriceFrom.toString());
    var toCont = TextEditingController(text: bloc.fsd?.fPriceTo.toString());
    
    return Drawer(
      child: ListView(
        controller: ScrollController(), // ScrollController is currently attached to more than one ScrollPosition.
        children: [
          ListTile(title: Text("sorting")),
          ListTile(
            leading: Radio<String>(
              value: "summ",
              groupValue: bloc.fsd?.sortCollumn,
              onChanged: (newVal) {
                bloc.inEvent.add(SupplySortCollumnChangedEvent(newVal!));
              }
            ),
            title: Text("по цене")
          ),
          ListTile(
            leading: Radio<String>(
              value: "supply_date",
              groupValue: bloc.fsd?.sortCollumn,
              onChanged: (newVal) {
                bloc.inEvent.add(SupplySortCollumnChangedEvent(newVal!));
              }
            ),
            title: Text("по дате")
          ),
          ListTile(title: AscDescDropdown()),
          ListTile(title: Text("filtering")),
          ListTile(title: Row(
            children: [
              Text("price: "),
              Expanded(child: TextFormField( // вынести в отдельный класс с стилями нужными
                controller: fromCont,
                textAlign: TextAlign.center,
                onChanged: (newVal) {
                  bloc.inEvent.add(SupplyFromPriceChangedEvent(newVal));
                }
              )),
              const Text("-"),
              Expanded(child: TextFormField(
                controller: toCont,
                textAlign: TextAlign.center,
                onChanged: (newVal) {
                  bloc.inEvent.add(SupplyToPriceChangedEvent(newVal));
                }
              )),
            ],
          )),
          ListTile(title: Row(
            children: [
              Text("date: "),
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
                  bloc.inEvent.add(SupplyFromDateChangedEvent(dateFrom));
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
                  bloc.inEvent.add(SupplyToDateChangedEvent(dateTo));
                },
              )),
            ],
          )),
          DataTable(
            columns: const [
              DataColumn(label: Text('постачальники', style: TextStyle(fontWeight: FontWeight.bold)))
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
                bloc.inEvent.add(SupplyLoadEvent());
              }, 
              child: const Text("find")
            ),
          ),
        ]
      )
    );
  }
}


class AscDescDropdown extends StatefulWidget {
  AscDescDropdown({Key? key}) : super(key: key);

  @override
  State<AscDescDropdown> createState() => _AscDescDropdownState();
}

class _AscDescDropdownState extends State<AscDescDropdown> {
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<SupplysBloc>(context);
    return DropdownButton<String>(
      value: bloc.fsd?.sortDirection,
      isExpanded: true,
      items: const [
        DropdownMenuItem(child: Text("по возрастанию"), value: "asc"),
        DropdownMenuItem(child: Text("по убыванию"), value: "desc")
      ],
      onChanged: (newVal) {
        bloc.inEvent.add(SupplySortDirectionChangedEvent(newVal!));
      },
    );
  }
}