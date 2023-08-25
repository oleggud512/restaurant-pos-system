import 'package:equatable/equatable.dart';

import '../../services/models.dart';

abstract class StoreEvent extends Equatable {
  const StoreEvent();
  @override
  List<Object?> get props => [];
}

class StoreLoadEvent extends StoreEvent { 
  
  @override
  List<Object?> get props => [];
}

class StoreReloadGroceriesEvent extends StoreEvent { 
  final String like;
  const StoreReloadGroceriesEvent({this.like=''});
}

class StoreSortGrocEvent extends StoreEvent {
  const StoreSortGrocEvent(this.direction);

  final Sorting direction;

  @override
  List<Object?> get props => [direction];
}


// class StoreGroceriesLoadEvent extends StoreLoadEvent { }


// class StoreSuppliersLoadEvent extends StoreLoadEvent { }


///////////////////////////////////////////////////////////////////////////////

class StoreState extends Equatable {

  @override
  get props => [];
}


/// one loading state and for suppliersCont and for groceriesCont
class StoreLoadingState extends StoreState { }

class StoreGroceriesLoadingState extends StoreState { }

class StoreSuppliersLoadingState extends StoreState { }

class StoreLoadedState extends StoreState { 
  final List<Supplier> suppliers;
  final List<Grocery> groceries;

  StoreLoadedState(this.suppliers, this.groceries);
}

// class StoreSuppliersLoadedState extends StoreState {
//   final List<Supplier> suppliers;

//   StoreSuppliersLoadedState(this.suppliers);
// }

// class StoreGroceriesLoadedState extends StoreState {
//   final List<Grocery> groceries;

//   StoreGroceriesLoadedState(this.groceries);
// }