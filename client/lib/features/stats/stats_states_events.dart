import 'package:equatable/equatable.dart';


class DashboardEvent extends Equatable {

  @override
  List<Object?> get props => [];
}

class DashboardLoadEvent extends DashboardEvent { }



///////////////////////////////////////////////////////////////////////////////

class DashboardState extends Equatable {

  @override
  List<Object?> get props => [];
}

class DashboardLoadingState extends DashboardState { }

class DashboardLoadedState extends DashboardState { }