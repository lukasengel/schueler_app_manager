import 'package:flutter/material.dart';

import 'package:schueler_app_manager/repositories/repositories.dart';

/// Interface definition for a localization repository.
/// A LocalizationRepository is responsible for loading translations for the application.
///
/// This class is meant to be extended by platform-specific implementations.
abstract class LocalizationRepository {
  // Define which implementation should be used througout the application
  static LocalizationRepository get instance {
    return AssetLocalizationRepository.instance;
  }

  /// Load specified locale from assets and global settings.
  ///
  /// Throws [LocalizationException] upon failure.
  Future<Map<String, String>> loadLocale(Locale locale);
}
