import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../utils/bloc_provider.dart';
import 'settings_events_states.dart';

class AppConfigBloc extends Bloc<SettingsBlocEvent, SettingsBlocState> {
  late File config;

  AppConfigBloc() : super(const SettingsBlocState());

  @override
  void handleEvent(SettingsBlocEvent event) async {
    switch (event) {
      case SettingsBlocLoadEvent(): 
        await loadConfig();
        break;
      case SettingsBlocBrightnessChangedEvent(brightness: final br): 
        await setBrightness(br);
        break;
      case SettingsBlocLanguageChangedEvent(locale: final ll):
        await setLocale(ll);
        break;
    };
  }

  Future<void> loadConfig() async {
    final docs = await getApplicationDocumentsDirectory();
    config = File('${docs.path}/${Constants.configFileName}');
    
    if (!await config.exists()) {
      await config.create();
      await config.writeAsString(jsonEncode(state.toJson()));
      return;
    }

    final data = jsonDecode(await config.readAsString()) as Map<String, dynamic>;
    emit(SettingsBlocState.fromJson(data));
  }

  Future<void> setBrightness(Brightness newBrightness) async {
    final newState = state.copyWith(brightness: newBrightness);
    await config.writeAsString(jsonEncode(newState.toJson()));
    emit(newState);
  }

  Future<void> setLocale(Locale newLocale) async {
    final newState = state.copyWith(locale: newLocale);
    await config.writeAsString(jsonEncode(newState.toJson()));
    emit(newState);
  }
}
