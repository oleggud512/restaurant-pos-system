import 'package:equatable/equatable.dart';


class DishDtEvent extends Equatable {

  @override
  List<Object?> get props => [];
}

/// тут будут загружаться: 
/// dish_id
/// dish_name
/// dish_price 
/// dish_gr_id
/// consist: такая же как в себестоимости
/// ну и себестоимость
class DishDtLoadEvent extends DishDtEvent { }

class DishDtEditEvent extends DishDtEvent { }


///////////////////////////////////////////////////////////////////////////////

class DishDtState extends Equatable {

  @override
  List<Object?> get props => [];
}

class DishDtLoadingState extends DishDtState { }

class DishDtLoadedState extends DishDtState { }