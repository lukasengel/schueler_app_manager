class LocalizationException implements Exception {
  final String message;
  final Object details;

  const LocalizationException(this.message, this.details);

  @override
  String toString() {
    return "LocalizationException: $message: $details";
  }
}
