import 'package:equatable/equatable.dart';


class MenuEvent extends Equatable {

  @override
  List<Object?> get props => [];
}

class MenuLoadEvent extends MenuEvent { }

class MenuReloadMenuEvent extends MenuEvent { }

class MenuReloadGroupsEvent extends MenuEvent { }

///////////////////////////////////////////////////////////////////////////////

class MenuState extends Equatable {

  @override
  List<Object?> get props => [];
}

class MenuLoadingState extends MenuState { }

class MenuLoadedState extends MenuState { }