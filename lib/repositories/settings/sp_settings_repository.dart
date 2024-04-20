import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:schueler_app_manager/common/common.dart';
import 'package:schueler_app_manager/models/models.dart';
import 'package:schueler_app_manager/exceptions/exceptions.dart';
import 'package:schueler_app_manager/repositories/repositories.dart';

/// Settings repository implementation using Shared Preferences.
class SPSettingsRepository extends SettingsRepository {
  // Make class a singleton
  SPSettingsRepository._();
  static final instance = SPSettingsRepository._();

  late SharedPreferences _preferences;
  late LocalSettings _localSettings;

  @override
  LocalSettings get localSettings => _localSettings;

  @override
  Future<bool> loadLocalSettings() async {
    try {
      _preferences = await SharedPreferences.getInstance();
      final localSettingsJson = _preferences.getString("localSettings");

      if (localSettingsJson != null) {
        _localSettings = LocalSettings.fromMap(json.decode(localSettingsJson));
        return true;
      }
    } catch (e) {
      AppLogger.instance.f("Failed to load local settings: $e");
    }

    return false;
  }

  @override
  Future<void> loadLocalDefaults() async {
    _localSettings = LocalSettings(
      locale: const Locale("de", "DE"),
      themeMode: ThemeMode.system,
      username: "",
      password: "",
    );
  }

  @override
  Future<void> updateLocalSettings(LocalSettings newLocalSettings) async {
    try {
      await _preferences.setString("localSettings", json.encode(newLocalSettings.toMap()));
      _localSettings = newLocalSettings;
    } catch (e) {
      AppLogger.instance.f("Failed to update local settings: $e");
      throw SettingsException("Failed to update local settings", e);
    }
  }

  @override
  Future<void> clearLocalSettings() async {
    try {
      await _preferences.clear();
      await loadLocalDefaults();
    } catch (e) {
      AppLogger.instance.f("Failed to clear local settings: $e");
      throw SettingsException("Failed to clear local settings", e);
    }
  }
}
