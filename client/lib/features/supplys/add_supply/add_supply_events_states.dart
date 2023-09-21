import 'package:client/services/entities/grocery/grocery.dart';
import 'package:client/services/entities/supplier.dart';
import 'package:client/services/entities/supply.dart';
import 'package:client/services/entities/grocery/supply_grocery.dart';
import 'package:client/utils/logger.dart';
import 'package:equatable/equatable.dart';



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

class AddSupplyNewCountEvent extends AddSupplyEvent {
  AddSupplyNewCountEvent(this.groc, String newCount) : newCount = double.parse((newCount.isNotEmpty) ? newCount : '0');
  final SupplyGrocery groc;
  final double newCount;

  @override
  List<Object?> get props => [groc, newCount];
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

class TotalSupplySummCalcException implements Exception { }

class AddSupplyState extends Equatable {
  AddSupplyState({
    this.isLoading = true,
    this.supplier,
    this.suppliers = const [],
    Supply? supply
  }) : supply = supply ?? Supply();


  final bool isLoading;
  /// selected supplier
  final Supplier? supplier;
  /// available suppliers
  final List<Supplier> suppliers;
  /// supply to add
  final Supply supply;


  double get totalSupplySumm {
    try {
      return supply.groceries.map((g) {
        if (g.supGrocPrice != null && g.grocCount != null) {
          return g.supGrocPrice! * g.grocCount!;
        }
        throw TotalSupplySummCalcException();
      }).reduce((p, n) => p + n);
    } on TotalSupplySummCalcException catch (_) {
      return 0;
    } on StateError catch (_) {
      return 0;
    }
  }


  @override
  List<Object?> get props => [
    isLoading,
    supplier,
    suppliers,
    supply
  ];


  AddSupplyState copyWith({
    bool? isLoading,
    Supplier? Function()? supplier,
    List<Supplier>? suppliers,
    Supply? supply
  }) {
    return AddSupplyState(
      isLoading: isLoading ?? this.isLoading,
      supplier: supplier != null ? supplier() : this.supplier,
      suppliers: suppliers ?? this.suppliers,
      supply: supply ?? this.supply,
    );
  }

}