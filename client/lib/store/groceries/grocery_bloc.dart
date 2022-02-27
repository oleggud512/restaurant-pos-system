import 'dart:async';

import 'package:client/services/repo.dart';
import 'package:rxdart/rxdart.dart';

import '../../bloc_provider.dart';
import '../../services/models.dart';
import 'grocery_states_events.dart';


class GroceryBloc extends Bloc {

  StreamController<GroceryEvent> _eventCont = BehaviorSubject<GroceryEvent>();
  Stream<GroceryEvent> get _outEvent => _eventCont.stream;
  Sink<GroceryEvent> get inEvent => _eventCont.sink;

  StreamController<GroceryState> _stateCont = BehaviorSubject<GroceryState>();
  Stream<GroceryState> get outState => _stateCont.stream;
  Sink<GroceryState> get _inState => _stateCont.sink;

  int id;
  Repo repo;
  bool isEdit = false;
  late Grocery grocery;

  GroceryBloc(this.repo, this.id) {
    _outEvent.listen((event) {_handleEvent(event);});
    inEvent.add(GrocLoadEvent());
  }

  _handleEvent(dynamic event) async {
    switch (event.runtimeType) {
      case GrocLoadEvent:
        _inState.add(GrocLoadingState());
        grocery = await repo.getGrocery(id);
        _inState.add(GrocLoadedState(grocery)); 
        break;
      case GrocEditEvent:
        isEdit = true;
        _inState.add(GrocEditState(grocery));
        break;
      case GrocSaveEvent:
        _inState.add(GrocLoadingState());
        await repo.updateGrocery(grocery);
        isEdit = false;
        _inState.add(GrocLoadedState(grocery));
        break;
      case GrocMeasureChanged:
        grocery.grocMeasure = event.newMeasure;
        _inState.add((isEdit) ? GrocEditState(grocery) : GrocLoadedState(grocery));
        break;
      case GrocNameChanged:
        grocery.grocName = event.newName;
        break;
      case GrocCountChanged:
        grocery.avaCount = event.newCount;
        break;
      default:
    }
  }

  @override
  void dispose() {
    
  }
}