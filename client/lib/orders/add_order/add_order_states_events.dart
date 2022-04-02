import 'package:equatable/equatable.dart';

import '../../services/models.dart';


class AddOrderEvent extends Equatable {

  @override
  List<Object?> get props => [];
}

class AddOrderLoadEvent extends AddOrderEvent { }

class AddOrderEmpChoosedEvent extends AddOrderEvent {
  AddOrderEmpChoosedEvent(this.empId);
  int empId;
}

class AddOrderCommentEvent extends AddOrderEvent {
  AddOrderCommentEvent(this.comm);
  String comm;
}

class AddOrderSelectGroupEvent extends AddOrderEvent {
  AddOrderSelectGroupEvent(this.index);
  int index;
}

class AddOrderFilterNameEvent extends AddOrderEvent {
  AddOrderFilterNameEvent(this.like);
  String like;
}

class AddOrderRemoveDishEvent extends AddOrderEvent {
  AddOrderRemoveDishEvent(this.index);
  int index;
}

class AddOrderAddDishEvent extends AddOrderEvent {
  AddOrderAddDishEvent(this.dish);
  Dish dish;
}

///////////////////////////////////////////////////////////////////////////////

class AddOrderState extends Equatable {

  @override
  List<Object?> get props => [];
}

class AddOrderLoadingState extends AddOrderState { }

class AddOrderLoadedState extends AddOrderState { }