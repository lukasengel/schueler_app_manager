class Broadcast {
  final String identifier;
  final String header;
  final String content;
  final DateTime datetime;

  const Broadcast({
    required this.identifier,
    required this.header,
    required this.content,
    required this.datetime,
  });

  factory Broadcast.fromMapEntry(MapEntry<String, dynamic> entry) {
    return Broadcast(
      identifier: entry.key,
      header: entry.value["header"],
      content: entry.value["content"],
      datetime: DateTime.parse(entry.value["datetime"]),
    );
  }

  MapEntry<String, dynamic> toMapEntry() {
    return MapEntry(identifier, {
      "header": header,
      "content": content,
      "datetime": datetime.toIso8601String(),
    });
  }
}
