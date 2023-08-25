import 'package:equatable/equatable.dart';



class MenuEvent extends Equatable {

  @override
  List<Object?> get props => [];
}

class MenuLoadEvent extends MenuEvent { }

class MenuReloadMenuEvent extends MenuEvent { }

class MenuReloadGroupsEvent extends MenuEvent { }

class MenuFiterGroceriesChangedEvent extends MenuEvent {
  MenuFiterGroceriesChangedEvent(this.grocIndex);
  final int grocIndex;
}

class MenuFiterGroupsChangedEvent extends MenuEvent {
  MenuFiterGroupsChangedEvent(this.groupIndex);
  final int groupIndex;
}

class MenuFilterDishNameEvent extends MenuEvent {
  MenuFilterDishNameEvent(this.like);
  final String like;
}

///////////////////////////////////////////////////////////////////////////////

class MenuState extends Equatable {

  @override
  List<Object?> get props => [];
}

class MenuLoadingState extends MenuState { }

class MenuLoadedState extends MenuState { }