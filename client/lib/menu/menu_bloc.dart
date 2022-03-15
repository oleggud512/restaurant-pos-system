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
  late FilterSortMenu fsMenu;
  // late DishFilterSortData dishFilterSortData;

  MenuBloc(this.repo) {
    _outEvent.listen((event) => _handleEvent(event),);
    inEvent.add(MenuLoadEvent());
  }

  _handleEvent(dynamic event) async {
    if (event is MenuLoadEvent) {
      _inState.add(MenuLoadingState());
      var data = await repo.getDishes();
      groups = data['groups'];
      dishes = data['dishes'];
      fsMenu = data['filter_sort_data'];
      _inState.add(MenuLoadedState());
    }
  }

  @override
  dispose() {
    _stateCont.close();
    _eventCont.close();
  }
}