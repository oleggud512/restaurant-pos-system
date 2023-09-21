import 'package:client/services/entities/employee.dart';
import 'package:equatable/equatable.dart';

import '../../../services/entities/dish.dart';
import '../../../services/entities/dish_group.dart';
import '../../../services/entities/order.dart';

class AddOrderState extends Equatable {
  AddOrderState({
    this.isLoading = false,
    this.employees = const [],
    this.dishes = const [],
    this.dishGroups = const [],
    this.selectedGroups = const [],
    Order? order,
    this.dishQuery = ''
  }) : order = order ?? Order();

  final bool isLoading;
  final List<Employee> employees;
  final List<Dish> dishes;
  final List<DishGroup> dishGroups;
  final List<DishGroup> selectedGroups;
  final Order order;
  final String dishQuery;

  AddOrderState copyWith({
    bool? isLoading,
    List<Employee>? employees,
    List<Dish>? dishes,
    List<DishGroup>? dishGroups,
    List<DishGroup>? selectedGroups,
    Order? order,
    String? dishQuery
  }) {
    return AddOrderState(
      isLoading: isLoading ?? this.isLoading,
      employees: employees ?? this.employees,
      dishes: dishes ?? this.dishes,
      dishGroups: dishGroups ?? this.dishGroups,
      selectedGroups: selectedGroups ?? this.selectedGroups,
      order: order ?? this.order,
      dishQuery: dishQuery ?? this.dishQuery,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    employees,
    dishes,
    dishGroups,
    selectedGroups,
    order,
    dishQuery
  ];
}

extension DishGroupSelection on AddOrderState {

  bool isDishGroupSelected(DishGroup group) {
    return selectedGroups.contains(group);
  }
}

extension FilteredDishes on AddOrderState {
  List<Dish> get filteredDishes => dishes.where(
    (d) => d.dishName.contains(dishQuery) &&
        selectedGroups.where((g) => g.groupId == d.dishGrId).isNotEmpty)
      .toList();
}