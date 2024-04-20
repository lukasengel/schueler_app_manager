import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:schueler_app_manager/repositories/repositories.dart';
import 'firebase_options.dart';

/// Initialize everything required by the application to start.
Future<void> initializeDependencies() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await _initiliazeRepositories();

  if (kIsWeb) {
    usePathUrlStrategy();
  }
}

/// Initliaze all application repositories.
Future<void> _initiliazeRepositories() async {
  await SettingsRepository.instance.initialize();
  await LocalizationRepository.instance.loadLocale(
    SettingsRepository.instance.localSettings.locale,
  );
}
