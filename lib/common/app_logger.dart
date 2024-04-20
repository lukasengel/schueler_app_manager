import 'package:logger/logger.dart';

/// Make a single logger instance available to the whole app.
class AppLogger {
  // Make constructor private
  AppLogger._();

  static final instance = Logger();
}
