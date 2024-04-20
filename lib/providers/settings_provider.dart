import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:schueler_app_manager/models/models.dart';
import 'package:schueler_app_manager/repositories/repositories.dart';

final settingsProvider = ChangeNotifierProvider((ref) => SettingsProvider(ref));

class SettingsProvider extends ChangeNotifier {
  // Store ref for accessing other providers
  // ignore: unused_field
  final Ref _ref;
  SettingsProvider(this._ref);

  // Make local settings accessible from anywhere in the app.
  LocalSettings _localSettings = SettingsRepository.instance.localSettings;

  // Getters
  LocalSettings get localSettings => _localSettings;

  /// Change the application locale of the current user.
  ///
  /// Make sure to catch possible [SettingsException]s.
  Future<void> changeLocale(Locale locale) async {
    await SettingsRepository.instance.updateLocalSettings(
      _localSettings.copyWith(locale: locale),
    );

    _update();
  }

  /// Change the theme mode of the current user.
  ///
  /// Make sure to catch possible [SettingsException]s.
  Future<void> changeThemeMode(ThemeMode themeMode) async {
    await SettingsRepository.instance.updateLocalSettings(
      _localSettings.copyWith(themeMode: themeMode),
    );

    _update();
  }

  /// Update the credentials of the current user.
  ///
  /// Make sure to catch possible [SettingsException]s.
  Future<void> updateCredentials(String username, String password) async {
    await SettingsRepository.instance.updateLocalSettings(SettingsRepository.instance.localSettings.copyWith(
      username: username,
      password: password,
    ));

    _update();
  }

  /// Clear the local settings of the current user.
  ///
  /// Make sure to catch possible [SettingsException]s.
  Future<void> clearLocalSettings() async {
    await SettingsRepository.instance.clearLocalSettings();
    _update();
  }

  /// Ensure that the copy of the settings is up-to-date.
  /// Then notify listeners.
  void _update() {
    _localSettings = SettingsRepository.instance.localSettings;
    notifyListeners();
  }
}
