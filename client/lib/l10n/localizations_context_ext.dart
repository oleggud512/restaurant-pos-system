import 'package:client/l10n/app_localizations.g.dart';
import 'package:flutter/material.dart';

extension LocalizationsContext on BuildContext {
  AppLocalizations? get ll {
    return AppLocalizations.of(this);
  }
}