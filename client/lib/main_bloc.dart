import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';
import 'main_states_events.dart';
import 'services/repo.dart';

class MainBloc extends Bloc {

  StreamController<MainEvent> _eventCont = BehaviorSubject<MainEvent>();
  Stream<MainEvent> get _outEvent => _eventCont.stream;
  Sink<MainEvent> get inEvent => _eventCont.sink;

  StreamController<MainState> _stateCont = BehaviorSubject<MainState>();
  Stream<MainState> get outState => _stateCont.stream;
  Sink<MainState> get _inState => _stateCont.sink;


  Brightness curBr = Brightness.light;
  Repo repo;

  MainBloc(this.repo) {
    _outEvent.listen((event) => _handleEvent(event),);
    inEvent.add(MainLoadEvent());
  }

  _handleEvent(dynamic event) {
    if (event is MainLoadEvent) { 
      _inState.add(MainLoadedState());
    } else if (event is MainBrightnessChanged) {
      curBr = event.brightness;
      _inState.add(MainLoadedState());
    }
  }


  @override
  dispose() {
    _stateCont.close();
    _eventCont.close();
  }
}