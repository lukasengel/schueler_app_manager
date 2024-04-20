class SettingsException implements Exception {
  final String message;
  final Object details;

  const SettingsException(this.message, this.details);

  @override
  String toString() {
    return "SettingsException: $message: $details";
  }
}
