import 'dart:async';
import 'package:rxdart/rxdart.dart';

import '../../bloc_provider.dart';
import '../../services/models.dart';
import '../../services/repo.dart';
import 'dish_details_states_events.dart';

class DishDtBloc extends Bloc {

  final StreamController<DishDtEvent> _eventCont = BehaviorSubject<DishDtEvent>();
  Stream<DishDtEvent> get _outEvent => _eventCont.stream;
  Sink<DishDtEvent> get inEvent => _eventCont.sink;

  final StreamController<DishDtState> _stateCont = BehaviorSubject<DishDtState>();
  Stream<DishDtState> get outState => _stateCont.stream;
  Sink<DishDtState> get _inState => _stateCont.sink;

  Repo repo;
  Dish dish;
  List<DishGroup> groups;
  var primeCost = <String, dynamic>{'total': 0};
  bool isEdit = false;

  DishDtBloc(this.repo, this.dish, this.groups) {
    _outEvent.listen((event) => _handleEvent(event),);
    inEvent.add(DishDtLoadEvent());
  }

  _handleEvent(dynamic event) async {
    if (event is DishDtLoadEvent) {
      _inState.add(DishDtLoadingState());
      primeCost = await repo.getPrimeCost(dish);
      _inState.add(DishDtLoadedState());
    } else if (event is DishDtEditEvent) {
      isEdit = !isEdit;
      _inState.add(DishDtLoadedState());
    }
  }


  @override
  dispose() {
    _stateCont.close();
    _eventCont.close();
  }
}