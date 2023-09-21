
import 'package:client/features/menu/domain/entities/prime_cost_data.dart';
import 'package:client/services/entities/dish.dart';
import 'package:client/services/entities/dish_group.dart';

import '../../../services/entities/filter_sort_menu_data.dart';
import '../../../utils/bloc_provider.dart';
import '../../../services/repo.dart';
import '../../../utils/logger.dart';
import 'dish_details_states_events.dart';

class DishDtBloc extends Bloc<DishDtEvent, DishDtState> {

  Repo repo;
  late Dish dish;
  late List<DishGroup> groups;
  PrimeCostData primeCost = const PrimeCostData();
  bool isEdit = false;

  final dishId;

  DishDtBloc(this.repo, this.dishId) : super(DishDtLoadingState());

  @override
  void handleEvent(DishDtEvent event) async {
    if (event is DishDtLoadEvent) {
      emit(DishDtLoadingState());
      dish = await repo.getDish(dishId);
      print(dish);
      groups = await repo.getAllDishGroups();
      primeCost = await repo.getPrimeCost(dish.dishGroceries);
      emit(DishDtLoadedState());
    } else if (event is DishDtEditEvent) {
      isEdit = !isEdit;
      emit(DishDtLoadedState());
    }
  }


}