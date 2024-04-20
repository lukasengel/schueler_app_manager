class FeedbackItem {
  final String identifier;
  final String message;
  final String? name;
  final String? email;

  const FeedbackItem({
    required this.identifier,
    required this.message,
    required this.name,
    required this.email,
  });

  factory FeedbackItem.fromMapEntry(MapEntry<String, dynamic> data) {
    return FeedbackItem(
      identifier: data.key,
      message: data.value["message"],
      name: data.value["name"],
      email: data.value["email"],
    );
  }

  MapEntry<String, dynamic> toMapEntry() {
    return MapEntry(identifier, {
      "message": message,
      "name": name,
      "email": email,
    });
  }
}
