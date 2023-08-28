import 'package:client/services/entities/grocery.dart';
import 'package:equatable/equatable.dart';

class GroceryEvent extends Equatable {
  
  @override 
  List<Object?> get props => [];
}

class GrocLoadEvent extends GroceryEvent { }

class GrocEditEvent extends GroceryEvent { }

class GrocSaveEvent extends GroceryEvent { }



class GrocMeasureChanged extends GroceryEvent {
  final String newMeasure;

  GrocMeasureChanged(this.newMeasure);
  
  @override
  List<Object?> get props => [newMeasure];
}

class GrocNameChanged extends GroceryEvent {
  final String newName;

  GrocNameChanged(this.newName);
  
  @override
  List<Object?> get props => [newName];
}

class GrocCountChanged extends GroceryEvent {
  final double newCount;

  GrocCountChanged(String newCount) : newCount = double.parse((newCount == '') ? '0' : newCount);
  
  @override
  List<Object?> get props => [newCount];
}

///////////////////////////////////////////////////////////////////////////////

class GroceryState extends Equatable {
  
  @override 
  List<Object?> get props => [];
}

class GrocLoadingState extends GroceryState { }

class GrocLoadedState extends GroceryState {
  final Grocery grocery;

  GrocLoadedState(this.grocery);

  @override
  List<Object?> get props => [grocery];
}

class GrocEditState extends GroceryState {
  final Grocery grocery;

  GrocEditState(this.grocery);
  
  @override
  List<Object?> get props => [grocery];
}