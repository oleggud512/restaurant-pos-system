import 'package:client/menu/dish_details/dish_details.dart';
import 'package:client/menu/menu_states_events.dart';
import 'package:client/menu/widgets/dish_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../bloc_provider.dart';
import '../services/repo.dart';
import 'add_dish/add_dish.dart';
import 'add_dish_group/add_dish_group_dialog.dart';
import 'menu_bloc.dart';
import 'menu_filter_sort/filter_sort_menu.dart';


class MenuPage extends StatefulWidget {
  MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MenuBloc>(
      blocBuilder: () => MenuBloc(Provider.of<Repo>(context)),
      blocDispose: (MenuBloc bloc) => bloc.dispose(),
      child: Builder(
        builder: (context) {
          MenuBloc bloc = BlocProvider.of<MenuBloc>(context);
          
          return StreamBuilder(
            stream: bloc.outState,
            builder: (context, snapshot) {
              var state = snapshot.data;
              if (state is MenuLoadingState) {
                return Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: CircularProgressIndicator())
                );
              }
              if (state is MenuLoadedState) {
                return Scaffold(
                  appBar: AppBar(
                    leading: BackButton( // понятия не имею, какого фига эта кнопка не появилась сама...
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
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
                              group: bloc.groups.firstWhere((element) => element.groupId == dish.dishGrId),
                              onTap: () async {
                                await Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => DishDetalsPage(dish: dish, groups: bloc.groups) // чтобы группу можно было менять
                                ));
                                bloc.inEvent.add(MenuLoadEvent());
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
                                await Navigator.push(context, MaterialPageRoute(builder: (context) => AddDishPage(groups: bloc.groups),));
                                bloc.inEvent.add(MenuLoadEvent());
                              }, 
                              icon: Icon(Icons.add), 
                              label: Text("dish")
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
                                bloc.inEvent.add(MenuLoadEvent());
                              }, 
                              icon: Icon(Icons.add), 
                              label: Text("group")
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
                  endDrawer: FilterSortMenuDrawer(),
                );
              } return Container(color: Colors.green);
            }
          );
        }
      )
    );
  }
}