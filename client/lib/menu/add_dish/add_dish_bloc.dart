import 'dart:async';
import 'package:rxdart/rxdart.dart';

import '../../bloc_provider.dart';
import '../../services/models.dart';
import '../../services/repo.dart';
import 'add_dish_states_events.dart';

class AddDishBloc extends Bloc {

  StreamController<AddDishEvent> _eventCont = BehaviorSubject<AddDishEvent>();
  Stream<AddDishEvent> get _outEvent => _eventCont.stream;
  Sink<AddDishEvent> get inEvent => _eventCont.sink;

  StreamController<AddDishState> _stateCont = BehaviorSubject<AddDishState>();
  Stream<AddDishState> get outState => _stateCont.stream;
  Sink<AddDishState> get _inState => _stateCont.sink;

  StreamController<AddDishState> _primeCostCont = BehaviorSubject<AddDishState>(); // something like state too
  Stream<AddDishState> get outPrimeCost => _primeCostCont.stream;
  Sink<AddDishState> get _inPrimeCost => _primeCostCont.sink;

  Repo repo;
  List<DishGroup> dishGroups;
  late List<Grocery> groceries;
  List<Grocery> tempGrocs = [];
  Dish dish = Dish.initial();
  double primeCost = 0;

  AddDishBloc(this.repo, this.dishGroups) {
    _outEvent.listen((event) => _handleEvent(event),);
    inEvent.add(AddDishLoadEvent());
  }

  _handleEvent(dynamic event) async {
    if (event is AddDishLoadEvent) {
      _inState.add(AddDishLoadingState());
      groceries = await repo.getGroceries();
      tempGrocs = List.from(groceries);
      _inPrimeCost.add(AddDishPrimeCostLoadedState());
      // await Future.delayed(Duration(seconds: 1), () => null);
    } 
    else if (event is AddDishFindGrocEvent) {
      tempGrocs = List<Grocery>.from(groceries.where((element) => element.grocName.contains(event.like)));
    } 
    else if (event is AddDishAddGrocEvent) {
      inEvent.add(AddDishLoadPrimeCostEvent());
      if (dish.dishGrocs.where((element) => element.grocId == event.groc.grocId).isEmpty) {
        dish.dishGrocs.add(DishGroc.initial(event.groc.grocId, event.groc.grocName));
      }
    } 
    else if (event is AddDishDishGrocCountChangedEvent) {
      inEvent.add(AddDishLoadPrimeCostEvent());
      dish.dishGrocs.firstWhere((element) => element.grocId == event.grocId).grocCount = event.newCount;
    }
    else if (event is AddDishRemoveGrocEvent) {
      dish.dishGrocs.removeAt(event.index);
      inEvent.add(AddDishLoadPrimeCostEvent());
    }
    else if (event is AddDishGroupChanged) {
      dish.dishGrId = event.newGroupId;
    }
    else if (event is AddDishPriceChangedEvent) {
      dish.dishPrice = event.price;
    }
    else if (event is AddDishNameChangedEvent) {
      dish.dishName = event.name;
    }
    else if (event is AddDishLoadPrimeCostEvent) {
      _inPrimeCost.add(AddDishPrimeCostLoadingState());
      if (dish.dishGrocs.isNotEmpty) {
        primeCost = await repo.getPrimeCost(dish);
      } else {
        primeCost = 0;
      }
      _inPrimeCost.add(AddDishPrimeCostLoadedState());
    }
    _inState.add(AddDishLoadedState(tempGrocs));
  }


  @override
  dispose() {
    _stateCont.close();
    _eventCont.close();
    _primeCostCont.close();
  }
}