import 'package:client/services/entities/dish.dart';
import 'package:client/services/entities/dish_group.dart';
import 'package:equatable/equatable.dart';



sealed class AddOrderEvent extends Equatable {

  @override
  List<Object?> get props => [];
}

class AddOrderLoadEvent extends AddOrderEvent { }

class AddOrderEmployeeSelectedEvent extends AddOrderEvent {
  AddOrderEmployeeSelectedEvent(this.empId);
  final int empId;
}

class AddOrderCommentChangedEvent extends AddOrderEvent {
  AddOrderCommentChangedEvent(this.comm);
  final String comm;
}

class AddOrderGroupSelectedChangedEvent extends AddOrderEvent {
  AddOrderGroupSelectedChangedEvent(this.dishGroup);
  final DishGroup dishGroup;
}

class AddOrderDishFilterChangedEvent extends AddOrderEvent {
  AddOrderDishFilterChangedEvent(this.dishQuery);
  final String dishQuery;
}

class AddOrderRemoveDishEvent extends AddOrderEvent {
  AddOrderRemoveDishEvent(this.index);
  final int index;
}

class AddOrderAddDishEvent extends AddOrderEvent {
  AddOrderAddDishEvent(this.dish);
  final Dish dish;
}

class AddOrderSubmitEvent extends AddOrderEvent {
  final void Function() onSuccess;
  AddOrderSubmitEvent({required this.onSuccess});
}