import 'package:client/services/entities/grocery.dart';
import 'package:equatable/equatable.dart';



class AddDishEvent extends Equatable {

  @override
  List<Object?> get props => [];
}

class AddDishLoadEvent extends AddDishEvent { }

class AddDishGroupSelectedEvent extends AddDishEvent { }

class AddDishFindGrocEvent extends AddDishEvent { 
  final String like;
  AddDishFindGrocEvent(this.like);
}

class AddDishAddGrocEvent extends AddDishEvent {
  AddDishAddGrocEvent(this.groc);
  final Grocery groc;
}

class AddDishDishGrocCountChangedEvent extends AddDishEvent {
  AddDishDishGrocCountChangedEvent(this.grocId, String newCount) : 
    newCount = double.parse(newCount.isEmpty ? '0.0' : newCount);
  final double newCount;
  final int grocId;
}

class AddDishRemoveGrocEvent extends AddDishEvent {
  AddDishRemoveGrocEvent(this.index);
  final int index;
}

class AddDishGroupChanged extends AddDishEvent {
  AddDishGroupChanged(this.newGroupId);
  final int newGroupId;
}

class AddDishPriceChangedEvent extends AddDishEvent {
  final double price;
  AddDishPriceChangedEvent(String pr) : price = double.parse(pr.isEmpty? "0.0" : pr);
}

class AddDishNameChangedEvent extends AddDishEvent {
  final String name;
  AddDishNameChangedEvent(this.name);
}

class AddDishLoadPrimeCostEvent extends AddDishEvent { }

///////////////////////////////////////////////////////////////////////////////

class AddDishState extends Equatable {

  @override
  List<Object?> get props => [];
}

class AddDishLoadingState extends AddDishState { }

class AddDishLoadedState extends AddDishState {  
  AddDishLoadedState(this.groceries);
  final List<Grocery> groceries;
}

class AddDishPrimeCostLoadingState extends AddDishState { }

class AddDishPrimeCostLoadedState extends AddDishState { }