import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:schueler_app_manager/common/common.dart';
import 'package:schueler_app_manager/exceptions/exceptions.dart';
import 'package:schueler_app_manager/repositories/repositories.dart';

/// Localization repository implementation for asset translations.
///
/// Translations are loaded from assets and buffered in memory.
/// If a translation is requested that is already loaded, it is returned from memory.
class AssetLocalizationRepository extends LocalizationRepository {
  // Make class a singleton
  AssetLocalizationRepository._();
  static final instance = AssetLocalizationRepository._();

  final Map<String, Map<String, String>> _translations = {};

  @override
  Future<Map<String, String>> loadLocale(Locale locale) async {
    try {
      final localeStr = locale.toString();

      Map<String, String> localizedStrings = {};

      // Only load translations from assets if not already loaded
      if (!_translations.containsKey(localeStr)) {
        final jsonString = await rootBundle.loadString("assets/lang/$localeStr.lang");
        final jsonMap = Map<String, dynamic>.from(json.decode(jsonString));
        localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
      } else {
        localizedStrings = _translations[localeStr]!;
      }

      // Save translations
      return localizedStrings;
    } catch (e) {
      AppLogger.instance.e("Failed to load locale: ${locale.toString()}: $e");
      throw LocalizationException("Failed to load locale: ${locale.toString()}", e);
    }
  }
}
