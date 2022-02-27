import 'package:equatable/equatable.dart';


class SupplyEvent extends Equatable {

  @override
  List<Object?> get props => [];
}

class SupplyLoadEvent extends SupplyEvent { }



///////////////////////////////////////////////////////////////////////////////

class SupplyState extends Equatable {

  @override
  List<Object?> get props => [];
}

class SupplyLoadingState extends SupplyState { }

class SupplyLoadedState extends SupplyState { }