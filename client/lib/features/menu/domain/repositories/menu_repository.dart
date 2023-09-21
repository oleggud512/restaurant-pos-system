import 'dart:io';

import 'package:client/features/menu/domain/entities/prime_cost_data.dart';
import 'package:client/services/entities/dish.dart';
import 'package:client/services/entities/grocery/dish_grocery.dart';
import 'package:client/services/entities/dish_group.dart';
import 'package:client/services/entities/filter_sort_menu_data.dart';

abstract interface class MenuRepository {
  Future<Dish> addDish(Dish dish, [File? photo]);
  Future<Dish> updateDish(Dish dish, [File? photo]);
  Future<Dish> getDish(int dishId);
  Future<List<Dish>> getDishes([FilterSortMenuData? filters]);
  Future<PrimeCostData> getPrimeCost(List<DishGrocery> groceries);
  Future<FilterSortMenuData> getFilterSortMenuData();
  Future<List<DishGroup>> getAllDishGroups();
  Future<DishGroup> addDishGroup(String name);
}