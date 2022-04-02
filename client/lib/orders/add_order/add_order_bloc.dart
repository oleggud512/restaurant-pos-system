import 'dart:async';
import 'package:rxdart/rxdart.dart';

import '../../bloc_provider.dart';
import '../../services/models.dart';
import '../../services/repo.dart';
import 'add_order_states_events.dart';

class AddOrderBloc extends Bloc {

  StreamController<AddOrderEvent> _eventCont = BehaviorSubject<AddOrderEvent>();
  Stream<AddOrderEvent> get _outEvent => _eventCont.stream;
  Sink<AddOrderEvent> get inEvent => _eventCont.sink;

  StreamController<AddOrderState> _stateCont = BehaviorSubject<AddOrderState>();
  Stream<AddOrderState> get outState => _stateCont.stream;
  Sink<AddOrderState> get _inState => _stateCont.sink;

  // StreamController<AddOrderState> _dishGroupsCont = BehaviorSubject<AddOrderState>();
  

  Repo repo;
  late List<Employee> emps;
  List<Dish> dishes;
  List<DishGroup> dishGroups;
  Order order = Order.init(0);
  String like = '';

  AddOrderBloc(this.repo, this.dishes, this.dishGroups) {
    _outEvent.listen((event) => _handleEvent(event),);
    inEvent.add(AddOrderLoadEvent());
  }

  _handleEvent(dynamic event) async {
    if (event is AddOrderLoadEvent) {
      _inState.add(AddOrderLoadingState());
      var data = await repo.getEmployees();
      emps = data['employees'];
      _inState.add(AddOrderLoadedState());
    } else if (event is AddOrderEmpChoosedEvent) {
      order.empId = event.empId;
      _inState.add(AddOrderLoadedState());
    } else if (event is AddOrderCommentEvent) {
      order.comm = event.comm;
    } else if (event is AddOrderSelectGroupEvent) {
      dishGroups[event.index].selected = !dishGroups[event.index].selected;
      _inState.add(AddOrderLoadedState());
    } else if (event is AddOrderFilterNameEvent) {
      like = event.like;
      _inState.add(AddOrderLoadedState());

    } else if (event is AddOrderRemoveDishEvent) {
      if (order.listOrders[event.index].count == 1) {
        order.listOrders.removeAt(event.index);
      } else if (order.listOrders[event.index].count > 1) {
        order.listOrders[event.index].decr();
      }
      order.refreshTotalPrice();
      print(order.listOrders);
      _inState.add(AddOrderLoadedState());

    } else if (event is AddOrderAddDishEvent) {
      if (order.listOrders.where((e) => e.dish.dishId == event.dish.dishId).isEmpty) {
        order.listOrders.add(OrderNode.toAdd(event.dish, 1));
      } else {
        order.listOrders.firstWhere((e) => e.dish.dishId == event.dish.dishId).incr();
      }
      order.refreshTotalPrice();
      _inState.add(AddOrderLoadedState());
    }
  }


  @override
  dispose() {
    _stateCont.close();
    _eventCont.close();
  }
}