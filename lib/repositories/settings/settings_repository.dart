import 'package:flutter/foundation.dart';

import 'package:schueler_app_manager/models/models.dart';
import 'package:schueler_app_manager/repositories/repositories.dart';

/// Interface definition for a settings repository.
/// Settings repositories are responsible for managing and persistent application settings.
///
/// This class is meant to be extended by platform-specific implementations.
abstract class SettingsRepository {
  // Define which implementation should be used througout the application
  static SettingsRepository get instance {
    return SPSettingsRepository.instance;
  }

  // Getters
  LocalSettings get localSettings;

  /// Initialize and load settings on program startup.
  ///
  /// Automatically load defaults in case of an error while loading.
  /// Throws a [SettingsException] if loading the defaults fails.
  Future<void> initialize() async {
    final local = await loadLocalSettings();

    if (!local) {
      await loadLocalDefaults();
    }
  }

  /// Specifies how to load local settings.
  ///
  /// Only meant for usage within [initialize].
  /// Returns [true] if succesful.
  @protected
  Future<bool> loadLocalSettings();

  /// Specifies how to load the default local settings.
  ///
  /// Only meant for usage within [initialize].
  /// Throws a [SettingsException] upon failure.
  @protected
  Future<void> loadLocalDefaults();

  /// Specifies how to update the local settings and write changes to persistent storage.
  ///
  /// Throws a [SettingsException] upon failure.
  Future<void> updateLocalSettings(LocalSettings newLocalSettings);

  /// Clear local settings and load defaults.
  ///
  /// Throws a [SettingsException] upon failure.
  Future<void> clearLocalSettings();
}
