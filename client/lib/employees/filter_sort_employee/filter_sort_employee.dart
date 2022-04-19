import 'package:client/employees/employees_bloc.dart';
import 'package:client/employees/employees_states_events.dart';
import 'package:client/l10nn/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../bloc_provider.dart';
import '../../supplys/filter_sort_drawer/filter_sort_drawer.dart';



class FilterSortEmployee extends StatefulWidget {
  const FilterSortEmployee({Key? key}) : super(key: key);

  @override
  State<FilterSortEmployee> createState() => _FilterSortEmployeeState();
}

class _FilterSortEmployeeState extends State<FilterSortEmployee> {
  late EmployeeBloc bloc;
  late TextEditingController likeCont;
  DateTime? df;
  DateTime? dt;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<EmployeeBloc>(context);
    df = DateTime.parse(bloc.fsEmp!.birthdayFrom.toString());
    dt = DateTime.parse(bloc.fsEmp!.birthdayTo.toString());
    likeCont = TextEditingController(text: bloc.like);
  }

  @override
  Widget build(BuildContext context) {
    // var bloc = BlocProvider.of<EmployeeBloc>(context);
    var l = AppLocalizations.of(context)!;
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              controller: ScrollController(),
              children: [
                ListTile(
                  title: Text(l.sorting)
                ),
                ListTile(
                  leading: Radio<String>(
                    value: 'emp_fname',
                    groupValue: bloc.fsEmp!.sortColumn,
                    onChanged: (newVal) {
                      setState(() {
                        bloc.fsEmp!.sortColumn = newVal!;
                      });
                    },
                  ),
                  title: Text(l.namee)
                ),
                ListTile(
                  leading: Radio<String>(
                    value: 'emp_lname',
                    groupValue: bloc.fsEmp!.sortColumn,
                    onChanged: (newVal) {
                      setState(() {
                        bloc.fsEmp!.sortColumn = newVal!;
                      });
                    },
                  ),
                  title: Text(l.surname)
                ),
                ListTile(
                  leading: Radio<String>(
                    value: 'birthday',
                    groupValue: bloc.fsEmp!.sortColumn,
                    onChanged: (newVal) {
                      setState(() {
                        bloc.fsEmp!.sortColumn = newVal!;
                      });
                    },
                  ),
                  title: Text(l.birthday)
                ),
                ListTile(
                  leading: Radio<String>(
                    value: 'hours_per_month',
                    groupValue: bloc.fsEmp!.sortColumn,
                    onChanged: (newVal) {
                      setState(() {
                        bloc.fsEmp!.sortColumn = newVal!;
                      });
                    },
                  ),
                  title: Text(l.hours_per_month)
                ),
                ListTile(title: AscDescDropdown(  // выбор направления
                  value: bloc.fsEmp!.asc,
                  onChanged: (newVal) {
                    setState(() {
                      bloc.fsEmp!.asc = newVal!;
                    });
                  }
                )),
                ListTile(
                  title: Text(l.filtering)
                ),
                ListTile(
                  title: TextFormField(
                    controller: likeCont,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: l.filtering,
                    ),
                    onChanged: (newVal) {
                      bloc.inEvent.add(EmployeeLikeChangedEvent(newVal));
                    },
                  )
                ),
                ListTile(
                  leading: Checkbox(
                    value: bloc.fsEmp!.gender.contains('m'),
                    onChanged: (newVal) {
                      bloc.inEvent.add(EmployeeFilterGenderEvent(newVal!, 'm'));
                    }
                  ),
                  title: Text(l.gen('m'))
                ),
                ListTile(
                  leading: Checkbox(
                    value: bloc.fsEmp!.gender.contains('f'),
                    onChanged: (newVal) {
                      bloc.inEvent.add(EmployeeFilterGenderEvent(newVal!, 'f'));
                    }
                  ),
                  title: Text(l.gen('f'))
                ),
                ListTile(title: Row( // дата от до
                  children: [
                    Text(l.birthday + ": "),
                    Expanded(child: TextButton(
                      child: Text(bloc.fsEmp!.birthdayFrom.toString().substring(0, 10)),
                      onPressed: () async {
                        DateTime dateFrom = await showDialog(
                          context: context,
                          builder: (context) {
                            return DatePickerDialog(
                              initialDate: bloc.fsEmp!.birthdayFrom, 
                              firstDate: df!, 
                              lastDate: dt!
                            );
                          }
                        );
                        setState(() {
                          bloc.fsEmp!.birthdayFrom = dateFrom;
                        });
                        // bloc.inEvent.add(SupplyFromDateChangedEvent(dateFrom));
                      },
                    )),
                    const Text("-"),
                    Expanded(child: TextButton(
                      child: Text(bloc.fsEmp!.birthdayTo.toString().substring(0, 10)),
                      onPressed: () async {
                        DateTime dateTo = await showDialog(
                          context: context,
                          builder: (context) {
                            return DatePickerDialog(
                              initialDate: bloc.fsEmp!.birthdayTo, 
                              firstDate: df!, 
                              lastDate: dt!
                            );
                          }
                        );
                        setState(() {
                          bloc.fsEmp!.birthdayTo = dateTo;
                        });
                        // bloc.inEvent.add(SupplyToDateChangedEvent(dateTo));
                      },
                    )),
                  ],
                )),
                ListTile(title: Row(              // цена от до
                  children: [
                    Text(l.hours + ": "),
                    Expanded(child: TextFormField( 
                      textAlign: TextAlign.center,
                      controller: TextEditingController(text: bloc.fsEmp!.hoursPerMonthFrom.toString()),
                      onChanged: (newVal) {
                        // bloc.inEvent.add(SupplyFromPriceChangedEvent(newVal));
                        bloc.fsEmp!.hoursPerMonthFrom = int.parse(newVal.isEmpty ? '0' : newVal);
                      }
                    )),
                    const Text("-"),
                    Expanded(child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: TextEditingController(text: bloc.fsEmp!.hoursPerMonthTo.toString()),
                      onChanged: (newVal) {
                        // bloc.inEvent.add(SupplyToPriceChangedEvent(newVal));
                        bloc.fsEmp!.hoursPerMonthTo = int.parse(newVal.isEmpty ? '0' : newVal);
                      },
                    )),
                  ],
                )),
                for (int i = 0; i < bloc.roles.length; i++) ListTile(
                  leading: Checkbox(
                    value: bloc.roles[i].selected,
                    onChanged: (newVal) {
                      bloc.inEvent.add(EmployeeRoleSelectedEvent(i, newVal!));
                    },
                  ),
                  title: Text(bloc.roles[i].roleName)
                )
              ],
            ),
          ),
          SizedBox(
            height: 30,
            child: Row(
              children: [
                ElevatedButton(
                  child: Text(l.find),
                  onPressed: () {
                    bloc.inEvent.add(EmployeeLoadEvent());
                  }
                ),
                ElevatedButton(
                  child: Text(l.clear),
                  onPressed: () {
                    bloc.fsEmp = null;
                    bloc.like = '';
                    bloc.inEvent.add(EmployeeLoadEvent());
                  }
                ),
              ],
            )
          )
        ],
      )
    );
  }
}