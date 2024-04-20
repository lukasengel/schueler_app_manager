class Credentials {
  final String username;
  final String password;
  final String url;

  const Credentials({
    required this.username,
    required this.password,
    required this.url,
  });

  factory Credentials.fromMap(Map<String, dynamic> data) {
    return Credentials(
      username: data["username"],
      password: data["password"],
      url: data["url"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "password": password,
      "url": url,
    };
  }
}
