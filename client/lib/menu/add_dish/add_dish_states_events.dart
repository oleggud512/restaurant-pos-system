import 'package:equatable/equatable.dart';

import '../../services/models.dart';


class AddDishEvent extends Equatable {

  @override
  List<Object?> get props => [];
}

class AddDishLoadEvent extends AddDishEvent { }

class AddDishGroupSelectedEvent extends AddDishEvent { }

class AddDishFindGrocEvent extends AddDishEvent { 
  String like;
  AddDishFindGrocEvent(this.like);
}

class AddDishAddGrocEvent extends AddDishEvent {
  AddDishAddGrocEvent(this.groc);
  Grocery groc;
}

class AddDishDishGrocCountChangedEvent extends AddDishEvent {
  AddDishDishGrocCountChangedEvent(this.grocId, String newCount) : 
    newCount = double.parse(newCount.isEmpty ? '0.0' : newCount);
  double newCount;
  int grocId;
}

class AddDishRemoveGrocEvent extends AddDishEvent {
  AddDishRemoveGrocEvent(this.index);
  int index;
}

class AddDishGroupChanged extends AddDishEvent {
  AddDishGroupChanged(this.newGroupId);
  int newGroupId;
}

class AddDishPriceChangedEvent extends AddDishEvent {
  double price;
  AddDishPriceChangedEvent(String pr) : price = double.parse(pr.isEmpty? "0.0" : pr);
}

class AddDishNameChangedEvent extends AddDishEvent {
  String name;
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
  List<Grocery> groceries;
}

class AddDishPrimeCostLoadingState extends AddDishState { }

class AddDishPrimeCostLoadedState extends AddDishState { }