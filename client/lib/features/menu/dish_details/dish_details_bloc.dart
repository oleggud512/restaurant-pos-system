
import 'package:client/services/entities/dish.dart';
import 'package:client/services/entities/dish_group.dart';

import '../../../utils/bloc_provider.dart';
import '../../../services/repo.dart';
import 'dish_details_states_events.dart';

class DishDtBloc extends Bloc<DishDtEvent, DishDtState> {

  Repo repo;
  Dish dish;
  List<DishGroup> groups;
  var primeCost = <String, dynamic>{'total': 0};
  bool isEdit = false;

  DishDtBloc(this.repo, this.dish, this.groups) : super(DishDtLoadingState());

  @override
  void handleEvent(dynamic event) async {
    if (event is DishDtLoadEvent) {
      emit(DishDtLoadingState());
      primeCost = await repo.getPrimeCost(dish);
      emit(DishDtLoadedState());
    } else if (event is DishDtEditEvent) {
      isEdit = !isEdit;
      emit(DishDtLoadedState());
    }
  }


}