import 'dart:async';
import 'dart:convert';
import 'dart:io';
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


  late Brightness curBr;
  late String curLang;
  late File config;
  Repo repo;

  MainBloc(this.repo) {
    _outEvent.listen((event) => _handleEvent(event),);
    inEvent.add(MainLoadEvent());
  }

  _handleEvent(dynamic event) {
    if (event is MainLoadEvent) { 
      config = File('lib/config.json');
      var data = jsonDecode(config.readAsStringSync());
      curBr = data['theme'] == 'dark' ? Brightness.dark : Brightness.light;
      curLang = data['language'];
      print('$curBr $curLang');
      _inState.add(MainLoadedState());
    } else if (event is MainBrightnessChanged) {
      curBr = event.brightness;
      var data = jsonDecode(config.readAsStringSync());
      data['theme'] = (curBr == Brightness.dark) ? 'dark' : 'light';
      config.writeAsStringSync(jsonEncode(data));
      _inState.add(MainLoadedState());
    } else if (event is MainLanguageChangedEvent) {
      curLang = event.newLang;
      var data = jsonDecode(config.readAsStringSync());
      data['language'] = curLang;
      config.writeAsStringSync(jsonEncode(data));
      _inState.add(MainLoadedState());
    }
  }


  @override
  dispose() {
    _stateCont.close();
    _eventCont.close();
  }
}