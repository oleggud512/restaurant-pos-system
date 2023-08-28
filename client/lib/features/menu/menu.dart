import 'package:client/features/menu/dish_details/dish_details.dart';
import 'package:client/features/menu/menu_states_events.dart';
import 'package:client/features/menu/widgets/dish_container.dart';
import 'package:client/l10n/localizations_context_ext.dart';
import 'package:client/services/entities/dish.dart';
import 'package:client/utils/sizes.dart';
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


class MenuPage extends StatelessWidget {
  MenuPage({Key? key}) : super(key: key);

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> showAddDishPage(BuildContext context, MenuBloc bloc) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => AddDishPage(groups: bloc.groups!),));
    bloc.add(MenuLoadEvent());
  }

  Future<void> showAddDishGroupDialog(BuildContext context, MenuBloc bloc) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AddDishGroupDialog();
      }
    );
    bloc.add(MenuLoadEvent());
  }

  Future<void> showDishPage(BuildContext context, MenuBloc bloc, Dish dish) async {
    await Navigator.push(context, MaterialPageRoute(
      builder: (context) => DishDetalsPage(dish: dish, groups: bloc.groups!) // чтобы группу можно было менять
    ));
    bloc.add(MenuLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    final ll = context.ll!;
    return BlocProvider<MenuBloc>(
      create: (_) => MenuBloc(context.read<Repo>())
        ..add(MenuLoadEvent()),
      child: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          final bloc = context.readBloc<MenuBloc>();
          return switch (state) {
            MenuLoadingState() => Scaffold(
              appBar: AppBar(leading: const ToggleDrawerButton(), title: const Center(child: Text('Menu'))),
              body: const Center(child: CircularProgressIndicator())
            ),
            MenuLoadedState() => Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text(ll.menu),
                automaticallyImplyLeading: false,
                leading: const ToggleDrawerButton(),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.filter_alt_outlined),
                    onPressed: () => scaffoldKey.currentState!.openEndDrawer()
                  )
                ]
              ),
              bottomNavigationBar: buildBottomBar(context, bloc),
              body: buildDishes(context, bloc),
              endDrawer: const FilterSortMenuDrawer(),
            ),
            _ => Container(color: Colors.green)
          };
        }
      )
    );
  }


  BottomAppBar buildBottomBar(BuildContext context, MenuBloc bloc) {
    final ll = context.ll!;
    return BottomAppBar(
      height: p56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(),
          TextButton.icon(
            onPressed: () => showAddDishPage(context, bloc), 
            icon: const Icon(Icons.add), 
            label: Text(ll.dish)
          ),
          w8gap,
          TextButton.icon(
            onPressed:() => showAddDishGroupDialog(context, bloc), 
            icon: const Icon(Icons.add), 
            label: Text(ll.group.toLowerCase())
          ),
        ],
      )
    );
  }

  Widget buildDishes(BuildContext context, MenuBloc bloc) {
    return ResponsiveGridList(
      desiredItemWidth: 250,
      children: bloc.toShowDishes.map((dish) => DishContainer(
        dish: dish, 
        group: bloc.groups!.firstWhere((group) => group.groupId == dish.dishGrId),
        onTap: () => showDishPage(context, bloc, dish)
      )).toList(),
    );
  }
}