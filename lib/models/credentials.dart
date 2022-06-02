class Credentials {
  final String username, password;
  const Credentials(this.username, this.password);

  bool get isNotEmpty {
    return username.isNotEmpty && password.isNotEmpty;
  }
}
