import 'dart:io';

import 'package:client/features/menu/add_dish/add_dish_page_mode.dart';
import 'package:client/features/menu/domain/entities/prime_cost_data.dart';
import 'package:equatable/equatable.dart';

import '../../../services/entities/dish.dart';
import '../../../services/entities/dish_group.dart';
import '../../../services/entities/grocery/grocery.dart';

class AddDishState extends Equatable {
  const AddDishState({
    this.isLoading = false,
    this.dishGroups = const [],
    this.groceries,
    this.searchStateGrocs = const [],
    this.dish = const Dish(),
    this.primeCostData = const PrimeCostData(),
    this.dishPhoto,
    this.mode = AddDishPageMode.add
  });

  final bool isLoading;
  final List<DishGroup> dishGroups;
  final List<Grocery>? groceries;
  final List<Grocery> searchStateGrocs;
  final Dish dish;
  final PrimeCostData primeCostData;
  final File? dishPhoto;
  final AddDishPageMode mode;

  AddDishState copyWith({
    bool? isLoading,
    List<DishGroup>? dishGroups,
    List<Grocery>? Function()? groceries,
    List<Grocery>? searchStateGrocs,
    Dish? dish,
    PrimeCostData? primeCostData,
    File? Function()? dishPhoto,
    AddDishPageMode? mode,
  }) => AddDishState(
    isLoading: isLoading ?? this.isLoading,
    dishGroups: dishGroups ?? this.dishGroups,
    groceries: groceries != null ? groceries() : this.groceries,
    searchStateGrocs: searchStateGrocs ?? this.searchStateGrocs,
    dish: dish ?? this.dish,
    primeCostData: primeCostData ?? this.primeCostData,
    dishPhoto: dishPhoto != null ? dishPhoto() : this.dishPhoto,
    mode: mode ?? this.mode,
  );

  bool get isEditDish => mode == AddDishPageMode.edit;
  bool get isAddDish => mode == AddDishPageMode.add;

  @override
  List<Object?> get props => [
    isLoading,
    dishGroups,
    groceries,
    searchStateGrocs,
    dish,
    primeCostData,
    dishPhoto,
    mode
  ];
}