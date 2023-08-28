import 'package:client/services/entities/grocery.dart';
import 'package:client/services/entities/mini_grocery.dart';
import 'package:client/services/entities/supplier.dart';
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
  final int? grocId;

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

///////////////////////////////////////state///////////////////////////////////

class SupState extends Equatable { 
  final bool isLoading;
  final int supplierId;
  /// is null only during initialization. If there is an internet connection, 
  /// then it won't be null. Else, you don't even need the state...
  final Supplier? supplier;
  final bool isShowAddGrocForm;
  final List<Grocery> groceries;
  final MiniGrocery grocToAdd;

  const SupState({
    this.isLoading = false,
    required this.supplierId,
    this.supplier,
    this.isShowAddGrocForm = false,
    this.groceries = const [],
    this.grocToAdd = const MiniGrocery()
  });

  SupState copyWith({
    bool? isLoading,
    int? supplierId,
    Supplier? supplier,
    bool? isShowAddGrocForm,
    List<Grocery>? groceries,
    MiniGrocery? grocToAdd
  }) {
    return SupState(
      isLoading: isLoading ?? this.isLoading,
      supplierId: supplierId ?? this.supplierId,
      supplier: supplier ?? this.supplier,
      isShowAddGrocForm: isShowAddGrocForm ?? this.isShowAddGrocForm,
      groceries: groceries ?? this.groceries,
      grocToAdd: grocToAdd ?? this.grocToAdd
    );
  }

  @override
  List<Object?> get props => [
    supplierId, 
    supplier, 
    isShowAddGrocForm, 
    groceries,
    grocToAdd,
    isLoading,
  ];
}


extension LoadableState on SupState {
  SupState startLoading() {
    return copyWith(isLoading: true);
  }

  SupState stopLoading() {
    return copyWith(isLoading: false);
  }
}