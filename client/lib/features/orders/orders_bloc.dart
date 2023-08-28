import 'package:client/services/entities/dish.dart';
import 'package:client/services/entities/dish_group.dart';
import 'package:client/services/entities/filter_sort_menu.dart';
import 'package:client/services/entities/order.dart';

import '../../utils/bloc_provider.dart';
import '../../services/repo.dart';
import 'orders_states_events.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {

  Repo repo;
  late List<Order> orders;
  late List<Dish> dishes;
  late List<DishGroup> groups;

  OrdersBloc(this.repo) : super(OrdersLoadingState());

  @override
  void handleEvent(OrdersEvent event) async {
    if (event is OrdersLoadEvent) {
      emit(OrdersLoadingState());
      orders = await repo.getOrders();
      var data = await repo.getDishes(fsMenu: FilterSortMenu.init());
      dishes = data['dishes'];
      groups = data['groups'];
      emit(OrdersLoadedState());
    } 
    else if (event is OrdersReloadEvent) {
      emit(OrdersLoadingState());
      orders = await repo.getOrders();
      emit(OrdersLoadedState());
    }
  }
}