import 'dart:async';
import 'package:rxdart/rxdart.dart';

import '../bloc_provider.dart';
import '../services/models.dart';
import '../services/repo.dart';
import 'stats_states_events.dart';

class StatsBloc extends Bloc {

  StreamController<StatsEvent> _eventCont = BehaviorSubject<StatsEvent>();
  Stream<StatsEvent> get _outEvent => _eventCont.stream;
  Sink<StatsEvent> get inEvent => _eventCont.sink;

  StreamController<StatsState> _stateCont = BehaviorSubject<StatsState>();
  Stream<StatsState> get outState => _stateCont.stream;
  Sink<StatsState> get _inState => _stateCont.sink;

  Repo repo;
  FilterSortStats? fsStats;
  late StatsData sdata;

  StatsBloc(this.repo) {
    _outEvent.listen((event) => _handleEvent(event),);
    inEvent.add(StatsLoadEvent());
  }

  _handleEvent(dynamic event) async {
    if (event is StatsLoadEvent) {
      _inState.add(StatsLoadingState());
      var data = await repo.getStats(fsStats: fsStats);
      fsStats ??= data['filter_sort_stats'];
      sdata = data['stats_data'];
      _inState.add(StatsLoadedState());
    }
  }


  @override
  dispose() {
    _stateCont.close();
    _eventCont.close();
  }
}