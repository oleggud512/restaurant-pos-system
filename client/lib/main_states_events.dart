import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';


class MainEvent extends Equatable {

  @override
  List<Object?> get props => [];
}

class MainLoadEvent extends MainEvent { }

class MainBrightnessChanged extends MainEvent {
  MainBrightnessChanged(this.brightness);
  Brightness brightness;

  @override
  List<Object?> get props => [brightness];
}

///////////////////////////////////////////////////////////////////////////////

class MainState extends Equatable {

  @override
  List<Object?> get props => [];
}

class MainLoadingState extends MainState { }

class MainLoadedState extends MainState { }