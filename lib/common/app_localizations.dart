import 'package:flutter/material.dart';

import 'package:schueler_app_manager/common/common.dart';
import 'package:schueler_app_manager/repositories/repositories.dart';

/// Class to handle translations
class AppLocalizations {
  final Locale _locale;
  late Map<String, String> _localizedStrings;

  static const supportedLocales = [
    Locale("de", "DE"),
    Locale("en", "US"),
  ];

  static const localeDisplayNames = {
    "de_DE": "Deutsch",
    "en_US": "English",
  };

  AppLocalizations(this._locale);

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of(context, AppLocalizations)!;
  }

  Future<void> load() async {
    try {
      _localizedStrings = await LocalizationRepository.instance.loadLocale(_locale);
    } catch (e) {
      AppLogger.instance.f(e);
    }
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}

/// LocalizationsDelegate in order to use AppLocalizations with MaterialApp
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.contains(locale);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
