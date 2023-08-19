import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:client/constants.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc_provider.dart';
import 'main_states_events.dart';
import 'services/repo.dart';

class MainBloc extends Bloc {

  final StreamController<MainEvent> _eventCont = BehaviorSubject<MainEvent>();
  Stream<MainEvent> get _outEvent => _eventCont.stream;
  Sink<MainEvent> get inEvent => _eventCont.sink;

  final StreamController<MainState> _stateCont = BehaviorSubject<MainState>();
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

  _handleEvent(dynamic event) async {
    if (event is MainLoadEvent) { 
      await loadConfig();
      _inState.add(MainLoadedState());
    } else if (event is MainBrightnessChanged) {
      await setBrightness(event.brightness);
      _inState.add(MainLoadedState());
    } else if (event is MainLanguageChangedEvent) {
      await setLanguage(event.newLang);
      _inState.add(MainLoadedState());
    }
  }

  Future<void> loadConfig() async {
    final docs = await getApplicationDocumentsDirectory();
    config = File('${docs.path}/${Constants.configFileName}');
    
    if (!await config.exists()) {
      curBr = Brightness.light;
      curLang = 'en';
      final data = {
        Constants.configLang: curLang,
        Constants.configBrightness: curBr.name
      };
      await config.create();
      await config.writeAsString(jsonEncode(data));
      return;
    }

    final data = jsonDecode(await config.readAsString()) as Map<String, dynamic>;

    curBr = Brightness.values.firstWhere(
      (b) => b.name == data[Constants.configBrightness]
    );
    curLang = data[Constants.configLang];
  }

  Future<void> setBrightness(Brightness newBrightness) async {
    curBr = newBrightness;
    final data = jsonDecode(await config.readAsString()) as Map<String, dynamic>;

    data[Constants.configBrightness] = newBrightness.name;

    await config.writeAsString(jsonEncode(data));
  }

  Future<void> setLanguage(String newLang) async {
    curLang = newLang;
    final data = jsonDecode(await config.readAsString()) as Map<String, dynamic>;

    data[Constants.configLang] = curLang;

    await config.writeAsString(jsonEncode(data));
  }




  @override
  dispose() {
    _stateCont.close();
    _eventCont.close();
  }
}