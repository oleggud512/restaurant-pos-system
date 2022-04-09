import 'package:equatable/equatable.dart';


class StatsEvent extends Equatable {

  @override
  List<Object?> get props => [];
}

class StatsLoadEvent extends StatsEvent { }



///////////////////////////////////////////////////////////////////////////////

class StatsState extends Equatable {

  @override
  List<Object?> get props => [];
}

class StatsLoadingState extends StatsState { }

class StatsLoadedState extends StatsState { }