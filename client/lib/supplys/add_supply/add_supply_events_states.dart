import 'package:equatable/equatable.dart';

import '../../services/models.dart';


class AddSupplyEvent extends Equatable {

  @override
  List<Object?> get props => [];
}

class AddSupplyLoadEvent extends AddSupplyEvent { }

class AddSupplySupplierSelectedEvent extends AddSupplyEvent {
  AddSupplySupplierSelectedEvent(this.supplier);
  final Supplier? supplier;
  
  @override
  List<Object?> get props => [supplier];
}

class AddSupplyNewCount extends AddSupplyEvent {
  AddSupplyNewCount(this.index, newCount) : newCount = double.parse(newCount);
  int index;
  double newCount;

  @override
  List<Object?> get props => [index, newCount];
}

class AddSupplyAddGrocToSupply extends AddSupplyEvent {
  AddSupplyAddGrocToSupply(this.grocery);
  Grocery grocery;

  @override
  List<Object?> get props => [grocery];
}

class AddSupplySUBMIT extends AddSupplyEvent { }


///////////////////////////////////////////////////////////////////////////////

class AddSupplyState extends Equatable {

  @override
  List<Object?> get props => [];
}

class AddSupplyLoadingState extends AddSupplyState { }

class AddSupplyLoadedState extends AddSupplyState { 
  AddSupplyLoadedState(this.suppliers);

  List<Supplier> suppliers;
}

class AddSupplyReloadedState extends AddSupplyState { }