import 'package:flutter/material.dart';

class AppLocale {
  static const en = Locale.fromSubtags(languageCode: 'en');
  static const ru = Locale.fromSubtags(languageCode: 'ru');
  static const uk = Locale.fromSubtags(languageCode: 'uk');

  static final all = [en, ru, uk];
}