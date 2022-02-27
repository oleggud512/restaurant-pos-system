import 'dart:async';
import 'package:rxdart/rxdart.dart';

import '../bloc_provider.dart';
import '../services/models.dart';
import '../services/repo.dart';
import 'supplys_states_events.dart';

class SupplysBloc extends Bloc {

  StreamController<SupplyEvent> _eventCont = BehaviorSubject<SupplyEvent>();
  Stream<SupplyEvent> get _outEvent => _eventCont.stream;
  Sink<SupplyEvent> get inEvent => _eventCont.sink;

  StreamController<SupplyState> _stateCont = BehaviorSubject<SupplyState>();
  Stream<SupplyState> get outState => _stateCont.stream;
  Sink<SupplyState> get _inState => _stateCont.sink;


  late List<Supply> supplys;
  Repo repo;

  SupplysBloc(this.repo) {
    _outEvent.listen((event) => _handleEvent(event),);
    inEvent.add(SupplyLoadEvent());
  }

  _handleEvent(dynamic event) async {
    switch (event.runtimeType) {
      case SupplyLoadEvent:
        _inState.add(SupplyLoadingState());
        supplys = await repo.getSupplys();
        _inState.add(SupplyLoadedState());
        break;
      default:
    }
  }

  @override
  dispose() {
    _stateCont.close();
    _eventCont.close();
  }
}