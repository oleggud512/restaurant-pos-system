
import '../../../utils/bloc_provider.dart';
import '../../../services/models.dart';
import '../../../services/repo.dart';
import 'add_order_states_events.dart';

class AddOrderBloc extends Bloc<AddOrderEvent, AddOrderState> {


  Repo repo;
  late List<Employee> emps;
  List<Dish> dishes;
  List<DishGroup> dishGroups;
  Order order = Order.init(0);
  String like = '';

  AddOrderBloc(this.repo, this.dishes, this.dishGroups) : super(AddOrderLoadingState());

  @override
  void handleEvent(dynamic event) async {
    if (event is AddOrderLoadEvent) {
      emit(AddOrderLoadingState());
      var data = await repo.getEmployees();
      emps = data['employees'];
      emit(AddOrderLoadedState());
    } else if (event is AddOrderEmpChoosedEvent) {
      order.empId = event.empId;
      emit(AddOrderLoadedState());
    } else if (event is AddOrderCommentEvent) {
      order.comm = event.comm;
    } else if (event is AddOrderSelectGroupEvent) {
      dishGroups[event.index].selected = !dishGroups[event.index].selected;
      emit(AddOrderLoadedState());
    } else if (event is AddOrderFilterNameEvent) {
      like = event.like;
      emit(AddOrderLoadedState());

    } else if (event is AddOrderRemoveDishEvent) {
      if (order.listOrders[event.index].count == 1) {
        order.listOrders.removeAt(event.index);
      } else if (order.listOrders[event.index].count > 1) {
        order.listOrders[event.index].decr();
      }
      order.refreshTotalPrice();
      // print(order.listOrders);
      emit(AddOrderLoadedState());

    } else if (event is AddOrderAddDishEvent) {
      if (order.listOrders.where((e) => e.dish.dishId == event.dish.dishId).isEmpty) {
        order.listOrders.add(OrderNode.toAdd(event.dish, 1));
      } else {
        order.listOrders.firstWhere((e) => e.dish.dishId == event.dish.dishId).incr();
      }
      order.refreshTotalPrice();
      emit(AddOrderLoadedState());
    }
  }

}