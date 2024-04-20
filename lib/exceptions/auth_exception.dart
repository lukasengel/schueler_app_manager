class AuthException implements Exception {
  final String message;
  final Object details;

  const AuthException(this.message, this.details);

  @override
  String toString() {
    return "AuthException: $message: $details";
  }
}
