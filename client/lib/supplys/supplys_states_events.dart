import 'package:equatable/equatable.dart';


class SupplyEvent extends Equatable {

  @override
  List<Object?> get props => [];
}

class SupplyLoadEvent extends SupplyEvent { }

class SupplySortCollumnChangedEvent extends SupplyEvent {
  final String sortCollumn;
  SupplySortCollumnChangedEvent(this.sortCollumn);

  @override
  List<Object?> get props => [sortCollumn];
}

class SupplySortDirectionChangedEvent extends SupplyEvent {
  final String sortDirection;
  SupplySortDirectionChangedEvent(this.sortDirection);

  @override
  List<Object?> get props => [sortDirection];
}

class SupplyFromPriceChangedEvent extends SupplyEvent {
  SupplyFromPriceChangedEvent(this.fromPrice);
  final String fromPrice;

  @override 
  List<Object?> get props => [fromPrice];
}

class SupplyToPriceChangedEvent extends SupplyEvent {
  SupplyToPriceChangedEvent(this.toPrice);
  final String toPrice;

  @override 
  List<Object?> get props => [toPrice];
}

class SupplyFromDateChangedEvent extends SupplyEvent {
  SupplyFromDateChangedEvent(this.fromDate);
  final DateTime fromDate;

  @override 
  List<Object?> get props => [fromDate];
}

class SupplyToDateChangedEvent extends SupplyEvent {
  SupplyToDateChangedEvent(this.toDate);
  final DateTime toDate;

  @override 
  List<Object?> get props => [toDate];
}


///////////////////////////////////////////////////////////////////////////////

class SupplyState extends Equatable {

  @override
  List<Object?> get props => [];
}

class SupplyLoadingState extends SupplyState { }

class SupplyLoadedState extends SupplyState { }