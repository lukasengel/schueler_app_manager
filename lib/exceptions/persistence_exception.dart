class PersistenceException implements Exception {
  final String message;
  final Object details;

  const PersistenceException(this.message, this.details);

  @override
  String toString() {
    return "PersistenceException: $message: $details";
  }
}
