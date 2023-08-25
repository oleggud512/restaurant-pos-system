import 'package:client/l10n/app_locale.dart';
import 'package:client/utils/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';


class SettingsBlocEvent extends Equatable {

  @override
  List<Object?> get props => [];
}

class SettingsBlocLoadEvent extends SettingsBlocEvent { }

class SettingsBlocBrightnessChangedEvent extends SettingsBlocEvent {
  SettingsBlocBrightnessChangedEvent(this.brightness);
  final Brightness brightness;

  @override
  List<Object?> get props => [brightness];
}

class SettingsBlocLanguageChangedEvent extends SettingsBlocEvent {
  SettingsBlocLanguageChangedEvent(this.locale);
  final Locale locale;
}

///////////////////////////////////////////////////////////////////////////////

class SettingsBlocState extends Equatable {
  final Brightness brightness;
  final Locale locale;

  const SettingsBlocState({
    this.brightness = Brightness.light,
    this.locale = AppLocale.en
  });

  SettingsBlocState copyWith({
    Brightness? brightness,
    Locale? locale
  }) {
    return SettingsBlocState(
      brightness: brightness ?? this.brightness,
      locale: locale ?? this.locale
    );
  }

  Map<String, dynamic> toJson() {
    return {
      Constants.configBrightness: brightness.name,
      Constants.configLang: locale.languageCode
    };
  }

  factory SettingsBlocState.fromJson(Map<String, dynamic> json) {
    return SettingsBlocState(
      brightness: Brightness.values.firstWhere(
        (b) => b.name == json[Constants.configBrightness]
      ),
      locale: Locale.fromSubtags(languageCode: json[Constants.configLang])
    );
  }

  @override
  List<Object?> get props => [brightness, locale];
}