import 'dart:async';
import 'dart:io';
import 'package:client/features/menu/domain/entities/prime_cost_data.dart';
import 'package:client/services/entities/grocery/dish_grocery.dart';
import 'package:client/services/entities/grocery/grocery.dart';
import 'package:client/utils/logger.dart';

import '../../../services/entities/dish.dart';
import '../../../utils/bloc_provider.dart';
import '../../../services/repo.dart';
import 'add_dish_events.dart';
import 'add_dish_page_mode.dart';
import 'add_dish_state.dart';

class AddDishBloc extends Bloc<AddDishEvent, AddDishState> {
  final Repo repo;
  final AddDishPageMode mode;

  AddDishBloc(this.repo, {
    required this.mode,
    Dish? dish
  }) : super(AddDishState(
    isLoading: true,
    dish: dish ?? const Dish(),
    mode: mode
  ));

  @override
  void handleEvent(AddDishEvent event) async { 
    switch (event) {
      case AddDishLoadEvent():
        await load();
        break;
      case AddDishFindGroceryEvent(like: final query):
        findGrocery(query);
        break;
      case AddDishGroupSelectedEvent():
        // NOTE: unimplemented event handlers
        glogger.w('unimplemented event handler');
        break;
      case AddDishAddGroceryEvent(groc: final grocToAdd):
        // check if the grocery is already added
        if (state.dish.dishGroceries.where((g) => g.grocId == grocToAdd.grocId).isNotEmpty) return;
        emit(state.copyWith(
          dish: state.dish.copyWith(
            dishGroceries: [...state.dish.dishGroceries, DishGrocery(
              grocId: grocToAdd.grocId, 
              grocName: grocToAdd.grocName
            )]
          )
        ));
        break;
      case AddDishDishGrocCountChangedEvent(
        grocId: final grocId, 
        newCount: final newCount,
      ):
        // emit(state.copyWith(isLoading: true));

        final newGrocs = [...state.dish.dishGroceries];
        final dishGrocI = newGrocs.indexWhere((groc) => groc.grocId == grocId);

        newGrocs[dishGrocI] = newGrocs[dishGrocI].copyWith(grocCount: newCount);

        final newDish = state.dish.copyWith(dishGroceries: newGrocs);
        final updatedPrimeCost = await getPrimeCost(newGrocs);

        emit(state.copyWith(
          isLoading: false,
          dish: newDish,
          primeCostData: updatedPrimeCost
        ));
        break;
      case AddDishRemoveDishGroceryEvent(grocId: final grocId):
        removeDishGrocery(grocId);
        break;
      case AddDishGroupChangedEvent(groupId: final groupId):
        emit(state.copyWith(dish: state.dish.copyWith(
          dishGrId: groupId
        )));
        break;
      case AddDishPriceChangedEvent(price: final price):
        emit(state.copyWith(dish: state.dish.copyWith(
          dishPrice: () => price
        )));
        break;
      case AddDishNameChangedEvent(name: final name):
        emit(state.copyWith(dish: state.dish.copyWith(
          dishName: name
        )));
        break;
      case AddDishDishDescriptionChangedEvent(descr: final newDescription): 
        emit(state.copyWith(
          dish: state.dish.copyWith(
            dishDescr: newDescription
          )
        ));
        break;
      case AddDishLoadPrimeCostEvent():
        final p = await getPrimeCost(state.dish.dishGroceries);
        emit(state.copyWith(primeCostData: p));
        break;
      case AddDishUpdateDishPhotoEvent(dishPhoto: final dishPhoto):
        updateDishPhoto(dishPhoto);
        break;
      case AddDishDeleteDishPhotoEvent():
        deleteDishPhoto();
        break;
      case AddDishSubmitEvent(onSuccess: final onSuccess):
        await submit(onSuccess);
        break;
    }
  }

  Future<void> load() async {
    final groceries = await repo.getGroceries(suppliedOnly: true);
    final groups = await repo.getAllDishGroups();
    final tempGrocs = List<Grocery>.from(groceries);
    // get prime cost only if there are some groceries
    final primeCost = state.dish.dishGroceries.isNotEmpty
        ? await repo.getPrimeCost(state.dish.dishGroceries)
        : null;
    emit(state.copyWith(
        isLoading: false,
        groceries: () => groceries,
        searchStateGrocs: tempGrocs,
        dishGroups: groups,
        primeCostData: primeCost,
    ));
  }

  void findGrocery(String query) {
    final searchStateGrocs = List<Grocery>.from(state.groceries?.where(
            (groc) => groc.grocName.contains(query)) ?? <Grocery>[]);
    emit(state.copyWith(
        searchStateGrocs: searchStateGrocs
    ));
  }

  void removeDishGrocery(int grocId) {
    emit(state.copyWith(
      dish: state.dish.copyWith(
        dishGroceries: [...state.dish.dishGroceries]
          ..removeWhere((g) => g.grocId == grocId)
      )
    ));
  }

  Future<void> updateDishPhoto(File newDishPhoto) async {
    emit(state.copyWith(dishPhoto: () => newDishPhoto));
  }


  void deleteDishPhoto() {
    emit(state.copyWith(dishPhoto: () => null));
  }

  Future<void> submit([void Function()? onSuccess]) async {
    // TODO: make add dish page be able to edit dish
    if (state.isEditDish) {
      glogger.i('trying to repo.updateDish');
      await repo.updateDish(state.dish, state.dishPhoto);
    } else {
      glogger.i('trying to repo.addDish');
      await repo.addDish(state.dish, state.dishPhoto);
    }
    onSuccess?.call();
  }

  Future<PrimeCostData> getPrimeCost(List<DishGrocery> groceries) async {
    if (groceries.isEmpty) return const PrimeCostData();
    final data = repo.getPrimeCost(groceries);
    return data;
  }
}