class Broadcast {
  final int identifier;
  final String header;
  final String content;
  final DateTime datetime;
  const Broadcast(this.header, this.content, this.datetime, this.identifier);

  factory Broadcast.fromJson(Map<String, dynamic> json, int identifier) {
    String getString(String key) {
      return json.containsKey(key) ? json[key] as String : "";
    }

    return Broadcast(
      getString("header"),
      getString("content"),
      DateTime.tryParse(getString("datetime")) ?? DateTime.now(),
      identifier,
    );
  }
}
