import 'package:flutter/material.dart';

import '../../bloc_provider.dart';
import '../../supplys/filter_sort_drawer/filter_sort_drawer.dart';
import '../menu_bloc.dart';


class FilterSortMenuDrawer extends StatefulWidget {
  FilterSortMenuDrawer({Key? key}) : super(key: key);

  @override
  State<FilterSortMenuDrawer> createState() => _FilterSortMenuDrawerState();
}

class _FilterSortMenuDrawerState extends State<FilterSortMenuDrawer> {
  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<MenuBloc>(context);
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(title: Text("sorting")),
                ListTile(  // выбор того по чем сортируем
                  leading: Radio<String>(
                    value: 'dish_name',
                    groupValue: bloc.fsMenu.sortColumn,
                    onChanged: (newVal) {
                      setState(() {
                        bloc.fsMenu.sortColumn = newVal!;
                      });
                    }
                  ),
                  title: Text("по назві")
                ),
                ListTile(  // выбор того по чем сортируем
                  leading: Radio<String>(
                    value: 'dish_price',
                    groupValue: bloc.fsMenu.sortColumn,
                    onChanged: (newVal) {
                      setState(() {
                        bloc.fsMenu.sortColumn = newVal!;
                      });
                    }
                  ),
                  title: Text("по ціні")
                ),
                ListTile(title: AscDescDropdown(
                  value: bloc.fsMenu.asc,
                  onChanged: (newVal) {
                    setState(() {
                      bloc.fsMenu.asc =  newVal!;
                    });
                  }
                )), // выбор направления
                ListTile(title: Text("filtering")), 
              ]
            ),
          ),
          Expanded(
            flex: 0,
            child: SizedBox(
              height: 40,
              // decoration: BoxDecoration(
              //   color: Theme.of(context).primaryColor,
              //   borderRadius: BorderRadius.vertical(top: Radius.circular(10))
              // ),
              child: InkWell(
                onTap: () {

                },
                onHover: (a) {
                  print(a);
                },
                hoverColor: Colors.green,
                child: Center(child: Text("find", style: TextStyle(color: Colors.white)),
                ),
              )
            ),
          )
        ]
      )
    );
  }
}