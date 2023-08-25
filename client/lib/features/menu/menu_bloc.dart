import 'package:client/services/models.dart';

import '../../utils/bloc_provider.dart';
import '../../services/repo.dart';
import 'menu_states_events.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {

  Repo repo;
  
  List<DishGroup>? groups;
  late List<Dish> dishes;
  late List<Dish> toShowDishes;
  FilterSortMenu? fsMenu;
  late List<Grocery> groceries;

  bool showGrocList = false;
  bool showGroupList = false;
  // late DishFilterSortData dishFilterSortData;

  MenuBloc(this.repo) : super(MenuLoadingState());

  @override
  void handleEvent(dynamic event) async {
    if (event is MenuLoadEvent) {
      emit(MenuLoadingState());
      Map<String, dynamic> data = await repo.getDishes(fsMenu: fsMenu);
      if (fsMenu == null) {
        groceries = await repo.getGroceries(suppliedOnly: false);
        fsMenu = await repo.getFilterSortMenu();
        // data = await repo.getDishes(fsMenu!);
      } 
      groups ??= data['groups'];
      dishes = data['dishes'];
      setShownDishes(fsMenu!.like);
      emit(MenuLoadedState());

    } else if (event is MenuFiterGroceriesChangedEvent) {
      groceries[event.grocIndex].selected = !groceries[event.grocIndex].selected;
      if (groceries[event.grocIndex].selected) {
        fsMenu!.groceries.add(groceries[event.grocIndex]);
      } else {
        fsMenu!.groceries.remove(groceries[event.grocIndex]);
      }
      emit(MenuLoadedState());

    } else if (event is MenuFiterGroupsChangedEvent) {
      groups![event.groupIndex].selected = !groups![event.groupIndex].selected;
      if (groups![event.groupIndex].selected) {
        fsMenu!.groups.add(groups![event.groupIndex]);
      } else {
        fsMenu!.groups.remove(groups![event.groupIndex]);
      }
      emit(MenuLoadedState());

    } else if (event is MenuFilterDishNameEvent) {
      fsMenu!.like = event.like;
      setShownDishes(event.like);
      emit(MenuLoadedState());
    
    }
  }

  void setShownDishes(String like) {
    toShowDishes = dishes.where((e) => e.dishName.contains(like)).toList();
  }
}