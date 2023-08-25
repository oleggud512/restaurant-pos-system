import 'package:equatable/equatable.dart';


class OrdersEvent extends Equatable {

  @override
  List<Object?> get props => [];
}

class OrdersLoadEvent extends OrdersEvent { }

class OrdersReloadEvent extends OrdersEvent { }

///////////////////////////////////////////////////////////////////////////////

class OrdersState extends Equatable {

  @override
  List<Object?> get props => [];
}

class OrdersLoadingState extends OrdersState { }

class OrdersLoadedState extends OrdersState { }