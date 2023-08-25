import 'package:equatable/equatable.dart';

import '../../../services/models.dart';


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
  AddSupplyNewCount(this.index, String newCount) : newCount = double.parse((newCount.isNotEmpty) ? newCount : '0');
  final int index;
  final double newCount;

  @override
  List<Object?> get props => [index, newCount];
}

class AddSupplyAddGrocToSupply extends AddSupplyEvent {
  AddSupplyAddGrocToSupply(this.grocery);
  final Grocery grocery;

  @override
  List<Object?> get props => [grocery];
}

class AddSupplyRemoveGrocFromSupply extends AddSupplyEvent {
  AddSupplyRemoveGrocFromSupply(this.grocId);

  final int grocId;

  @override
  List<Object?> get props => [grocId];
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

  final List<Supplier> suppliers;
}

class AddSupplyReloadedState extends AddSupplyState { }