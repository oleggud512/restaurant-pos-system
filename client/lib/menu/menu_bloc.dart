import 'dart:async';
import 'package:client/services/models.dart';
import 'package:rxdart/rxdart.dart';

import '../bloc_provider.dart';
import '../services/repo.dart';
import 'menu_states_events.dart';

class MenuBloc extends Bloc {

  StreamController<MenuEvent> _eventCont = BehaviorSubject<MenuEvent>();
  Stream<MenuEvent> get _outEvent => _eventCont.stream;
  Sink<MenuEvent> get inEvent => _eventCont.sink;

  StreamController<MenuState> _stateCont = BehaviorSubject<MenuState>();
  Stream<MenuState> get outState => _stateCont.stream;
  Sink<MenuState> get _inState => _stateCont.sink;

  Repo repo;
  
  late List<DishGroup> groups;
  late List<Dish> dishes;
  late List<Dish> toShowDishes;
  FilterSortMenu? fsMenu;
  late List<Grocery> groceries;

  bool showGrocList = false;
  bool showGroupList = false;
  // late DishFilterSortData dishFilterSortData;

  MenuBloc(this.repo) {
    _outEvent.listen((event) => _handleEvent(event),);
    inEvent.add(MenuLoadEvent());
  }

  _handleEvent(dynamic event) async {
    if (event is MenuLoadEvent) {
      _inState.add(MenuLoadingState());

      groceries = await repo.getGroceries(suppliedOnly: false);
      fsMenu ??= await repo.getFilterSortMenu();

      var data = await repo.getDishes(fsMenu!);
      groups = data['groups'];
      dishes = data['dishes'];
      setShownDishes(fsMenu!.like);
      _inState.add(MenuLoadedState());
    } else if (event is MenuFiterGroceriesChangedEvent) {
      groceries[event.grocIndex].selected = !groceries[event.grocIndex].selected;
      if (groceries[event.grocIndex].selected) {
        fsMenu!.groceries.add(groceries[event.grocIndex]);
      } else {
        fsMenu!.groceries.remove(groceries[event.grocIndex]);
      }
      _inState.add(MenuLoadedState());
    } else if (event is MenuFiterGroupsChangedEvent) {
      groups[event.groupIndex].selected = !groups[event.groupIndex].selected;
      if (groups[event.groupIndex].selected) {
        fsMenu!.groups.add(groups[event.groupIndex]);
      } else {
        fsMenu!.groups.remove(groups[event.groupIndex]);
      }
      _inState.add(MenuLoadedState());
    } else if (event is MenuFilterDishNameEvent) {
      fsMenu!.like = event.like;
      setShownDishes(event.like);
      _inState.add(MenuLoadedState());
    }
  }

  void setShownDishes(String like) {
    toShowDishes = dishes.where((e) => e.dishName.contains(like)).toList();
  }

  @override
  dispose() {
    _stateCont.close();
    _eventCont.close();
  }
}