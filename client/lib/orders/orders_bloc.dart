import 'dart:async';
import 'package:rxdart/rxdart.dart';

import '../bloc_provider.dart';
import '../services/models.dart';
import '../services/repo.dart';
import 'orders_states_events.dart';

class OrdersBloc extends Bloc {

  StreamController<OrdersEvent> _eventCont = BehaviorSubject<OrdersEvent>();
  Stream<OrdersEvent> get _outEvent => _eventCont.stream;
  Sink<OrdersEvent> get inEvent => _eventCont.sink;

  StreamController<OrdersState> _stateCont = BehaviorSubject<OrdersState>();
  Stream<OrdersState> get outState => _stateCont.stream;
  Sink<OrdersState> get _inState => _stateCont.sink;

  Repo repo;
  late List<Order> orders;
  late List<Dish> dishes;
  late List<DishGroup> groups;

  OrdersBloc(this.repo) {
    _outEvent.listen((event) => _handleEvent(event),);
    
    inEvent.add(OrdersLoadEvent());
  }

  _handleEvent(dynamic event) async {
    if (event is OrdersLoadEvent) {
      _inState.add(OrdersLoadingState());
      orders = await repo.getOrders();
      var data = await repo.getDishes(fsMenu: FilterSortMenu.init());
      dishes = data['dishes'];
      groups = data['groups'];
      _inState.add(OrdersLoadedState());
    } 
    else if (event is OrdersReloadEvent) {
      _inState.add(OrdersLoadingState());
      orders = await repo.getOrders();
      _inState.add(OrdersLoadedState());
    }
  }


  @override
  dispose() {
    _stateCont.close();
    _eventCont.close();
  }
}