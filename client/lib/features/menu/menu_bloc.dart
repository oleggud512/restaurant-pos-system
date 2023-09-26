
import 'package:client/services/entities/dish.dart';
import 'package:client/services/entities/dish_group.dart';
import 'package:client/services/entities/filter_sort_menu_data.dart';
import 'package:client/services/entities/grocery/grocery.dart';

import '../../utils/bloc_provider.dart';
import '../../services/repo.dart';
import 'menu_states_events.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {

  Repo repo;
  
  List<DishGroup>? groups;
  late List<Dish> dishes;
  late List<Dish> filteredDishes;
  FilterSortMenuData? fsMenu;
  late List<Grocery> groceries;

  bool showGrocList = false;
  bool showGroupList = false;
  // late DishFilterSortData dishFilterSortData;

  MenuBloc(this.repo) : super(MenuLoadingState());

  @override
  void handleEvent(MenuEvent event) async {
    if (event case MenuLoadEvent()) {
      emit(MenuLoadingState());

      // fetch filters and groceries only a single time.
      if (fsMenu == null) {
        fsMenu = await repo.getFilterSortMenuData();
        groceries = await repo.getGroceries(suppliedOnly: false);
      }

      groups ??= await repo.getAllDishGroups();

      dishes = await repo.getDishes(fsMenu);
      filteredDishes = getFilteredDishesByName(fsMenu!.like);

      emit(MenuLoadedState());

    } else if (event case MenuFiterGroceriesChangedEvent(:final grocIndex)) {
      groceries[grocIndex].selected = !groceries[grocIndex].selected;
      if (groceries[grocIndex].selected) {
        fsMenu!.groceries.add(groceries[grocIndex]);
      } else {
        fsMenu!.groceries.remove(groceries[grocIndex]);
      }
      emit(MenuLoadedState());

    } else if (event case MenuToggleFilterDishGroupEvent(:final group)) {
      if (fsMenu!.groups.contains(group)) {
        fsMenu!.groups.add(group);
      } else {
        fsMenu!.groups.remove(group);
      }
      emit(MenuLoadedState());

    } else if (event case MenuFilterDishNameEvent(:final like)) {
      fsMenu!.like = like;
      filteredDishes = getFilteredDishesByName(like);
      emit(MenuLoadedState());
    
    }
  }

  List<Dish> getFilteredDishesByName(String like) {
    return dishes.where((e) => e.dishName.contains(like)).toList();
  }
}