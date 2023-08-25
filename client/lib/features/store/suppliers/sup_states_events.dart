import 'package:equatable/equatable.dart';

class SupEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SupLoadEvent extends SupEvent { }

/// добавляем через апи, потом перезагружаем полностью поставщика
class SupShowAddGroceryFormEvent extends SupEvent { }

class SupHideAddGroceryFormEvent extends SupEvent { }

class SupAddGroceryEvent extends SupEvent { }

class SupDeleteGroceryEvent extends SupEvent {
  final int grocId;

  SupDeleteGroceryEvent(this.grocId);
}


class ToAddGrocIdChanged extends SupEvent {
  final int grocId;

  ToAddGrocIdChanged(this.grocId);

  @override
  List<Object?> get props => [grocId];
}


class ToAddGrocCountChanged extends SupEvent {
  final double? supGrocPrice;

  ToAddGrocCountChanged(String supGrocPrice) : 
    supGrocPrice = supGrocPrice.isNotEmpty ? double.parse(supGrocPrice) : null;
  
  @override
  List<Object?> get props => [supGrocPrice];
}

class SupCommitEvent extends SupEvent { }

///////////////////////////////////////////////////////////////////////////////

class SupState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SupLoadingState extends SupState { }

class SupLoadedState extends SupState { }