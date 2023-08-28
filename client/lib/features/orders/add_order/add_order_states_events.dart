import 'package:client/services/entities/dish.dart';
import 'package:equatable/equatable.dart';



class AddOrderEvent extends Equatable {

  @override
  List<Object?> get props => [];
}

class AddOrderLoadEvent extends AddOrderEvent { }

class AddOrderEmpChoosedEvent extends AddOrderEvent {
  AddOrderEmpChoosedEvent(this.empId);
  final int empId;
}

class AddOrderCommentEvent extends AddOrderEvent {
  AddOrderCommentEvent(this.comm);
  final String comm;
}

class AddOrderSelectGroupEvent extends AddOrderEvent {
  AddOrderSelectGroupEvent(this.index);
  final int index;
}

class AddOrderFilterNameEvent extends AddOrderEvent {
  AddOrderFilterNameEvent(this.like);
  final String like;
}

class AddOrderRemoveDishEvent extends AddOrderEvent {
  AddOrderRemoveDishEvent(this.index);
  final int index;
}

class AddOrderAddDishEvent extends AddOrderEvent {
  AddOrderAddDishEvent(this.dish);
  final Dish dish;
}

///////////////////////////////////////////////////////////////////////////////

class AddOrderState extends Equatable {

  @override
  List<Object?> get props => [];
}

class AddOrderLoadingState extends AddOrderState { }

class AddOrderLoadedState extends AddOrderState { }