import 'package:client/l10n/app_localizations.g.dart';
import 'package:client/features/menu/dish_details/dish_details.dart';
import 'package:client/features/menu/menu_states_events.dart';
import 'package:client/features/menu/widgets/dish_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../utils/bloc_provider.dart';
import '../../services/repo.dart';
import '../home/toggle_drawer_button.dart';
import 'add_dish/add_dish.dart';
import 'add_dish_group/add_dish_group_dialog.dart';
import 'menu_bloc.dart';
import 'menu_filter_sort/filter_sort_menu.dart';


class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var l = AppLocalizations.of(context)!;
    return BlocProvider<MenuBloc>(
      create: (_) => MenuBloc(Provider.of<Repo>(context))
        ..add(MenuLoadEvent()),
      child: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          final bloc = context.readBloc<MenuBloc>();
          if (state is MenuLoadingState) {
            return Scaffold(
              appBar: AppBar(leading: const ToggleDrawerButton(), title: const Center(child: Text('Menu'))),
              body: const Center(child: CircularProgressIndicator())
            );
          }
          if (state is MenuLoadedState) {
            print("HERE IS MY FSMENU: ${bloc.fsMenu!.toJson()}");
            return Scaffold(
              key: key,
              appBar: AppBar(
                title: Text(l.menu),
                automaticallyImplyLeading: false,
                leading: const ToggleDrawerButton(),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.filter_alt_outlined),
                    onPressed: () => key.currentState!.openEndDrawer()
                  )
                ]
              ),
              body: Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 1,
                    child: ResponsiveGridList(
                      desiredItemWidth: 250,
                      children: [
                        for (var dish in bloc.toShowDishes) DishContainer(
                          dish: dish, 
                          group: bloc.groups!.firstWhere((element) => element.groupId == dish.dishGrId),
                          onTap: () async {
                            await Navigator.push(context, MaterialPageRoute(
                              builder: (context) => DishDetalsPage(dish: dish, groups: bloc.groups!) // чтобы группу можно было менять
                            ));
                            bloc.add(MenuLoadEvent());
                          }
                        )
                      ],
                    ),
                  ),
                  Container(
                    // margin: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey, // 
                          offset: Offset(0.0, 0.0), //(x,y)
                          blurRadius: 10.0,
                        ),
                      ],
                      // color: Colors.blue,
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(10))
                    ),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () async {
                            // await Navigator.pushNamed(context, '/menu/add-dish', arguments: {'groups' : bloc.groups});
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => AddDishPage(groups: bloc.groups!),));
                            bloc.add(MenuLoadEvent());
                          }, 
                          icon: const Icon(Icons.add), 
                          label: Text(l.dish)
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: () async {
                            // диалог добавления группы
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return AddDishGroupDialog();
                              }
                            );
                            bloc.add(MenuLoadEvent());
                          }, 
                          icon: const Icon(Icons.add), 
                          label: Text(l.group.toLowerCase())
                        ),
                        const SizedBox(width: 8),
                      ],
                    )
                  ), 
                ],
              ),
              // bottomNavigationBar: BottomNavigationBar(
              //   items: [
              //     BottomNavigationBarItem(icon: Icon(Icons.menu_book_rounded), label: "Menu"),
              //     BottomNavigationBarItem(icon: Icon(Icons.dinner_dining_rounded), label: "Add Dish"),
              //     BottomNavigationBarItem(icon: Icon(Icons.collections_bookmark_rounded), label: "Add Group"),
              //   ], 
              //   onTap: (i) {
              //     print(i);
              //   },
              // )
              endDrawer: const FilterSortMenuDrawer(),
            );
          } return Container(color: Colors.green);
        }
      )
    );
  }
}