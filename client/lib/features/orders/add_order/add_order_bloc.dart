
import 'package:client/features/orders/add_order/add_order_state.dart';
import 'package:client/services/entities/dish.dart';
import 'package:client/services/entities/dish_group.dart';
import 'package:client/services/entities/order_node.dart';
import 'package:client/utils/logger.dart';
import 'package:either_dart/either.dart';

import '../../../utils/bloc_provider.dart';
import '../../../services/repo.dart';
import 'add_order_events.dart';

class AddOrderBloc extends Bloc<AddOrderEvent, AddOrderState> {
  AddOrderBloc(this.repo, List<Dish> dishes, List<DishGroup> dishGroups)
    : super(AddOrderState(dishes: dishes, dishGroups: dishGroups));


  Repo repo;


  @override
  void handleEvent(AddOrderEvent event) async {
    switch (event) {
      case AddOrderLoadEvent():
        await load();
        break;
      case AddOrderEmployeeSelectedEvent(:final empId):
        selectEmployee(empId);
        break;
      case AddOrderCommentChangedEvent(:final comm):
        commentChanged(comm);
        break;
      case AddOrderGroupSelectedChangedEvent(:final dishGroup):
        selectGroup(dishGroup);
        break;
      case AddOrderDishFilterChangedEvent(:final dishQuery):
        changeQuery(dishQuery);
        break;
      case AddOrderRemoveDishEvent(:final index):
        removeDish(index);
        break;
      case AddOrderAddDishEvent(:final dish):
        addDish(dish);
        break;
      case AddOrderSubmitEvent(:final onSuccess):
        (await submit()).map((r) => onSuccess());
        break;
    }
  }


  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    final data = await repo.getEmployees();
    final employees = data['employees'];
    emit(state.copyWith(
        isLoading: false,
        employees: employees
    ));
  }


  void selectEmployee(int empId) {
    emit(state.copyWith(
      order: state.order.copyWith(
        empId: () => empId
      )
    ));
  }


  void commentChanged(String newComment) {
    emit(state.copyWith(
      order: state.order.copyWith(
        comm: newComment
      )
    ));
  }


  void selectGroup(DishGroup dishGroup) {
    final newSelectedGroups = [...state.selectedGroups];
    if (state.isDishGroupSelected(dishGroup)) {
      newSelectedGroups.remove(dishGroup);
    } else {
      newSelectedGroups.add(dishGroup);
    }
    emit(state.copyWith(
      selectedGroups: newSelectedGroups
    ));
  }


  void changeQuery(String newDishQuery) {
    emit(state.copyWith(
      dishQuery: newDishQuery
    ));
  }


  void removeDish(int dishIndex) {
    final newListOrders = [...state.order.listOrders];

    if (newListOrders[dishIndex].count == 1) {
      newListOrders.removeAt(dishIndex);
    } else if (newListOrders[dishIndex].count > 1) {
      newListOrders[dishIndex].decrement();
    }

    emit(state.copyWith(
      order: state.order.copyWith(listOrders: newListOrders).refreshTotalPrice()
    ));
  }


  void addDish(Dish dish) {
    final newListOrders = [...state.order.listOrders];

    if (state.order.listOrders.where((e) => e.dish.dishId == dish.dishId).isEmpty) {
      newListOrders.add(OrderNode.toAdd(dish, 1));
    } else {
      newListOrders.firstWhere((e) => e.dish.dishId == dish.dishId).increment();
    }

    emit(state.copyWith(
      order: state.order.copyWith(listOrders: newListOrders).refreshTotalPrice()
    ));
  }

  Future<Either<Exception, void>> submit() async {
    try {
      await repo.addOrder(state.order);
      return const Right(null);
    } on Exception catch (e) {
      glogger.e(e);
      return Left(e);
    }
  }


}