class Teacher {
  final String identifier;
  final String name;

  const Teacher({
    required this.identifier,
    required this.name,
  });

  factory Teacher.fromMapEntry(MapEntry<String, dynamic> entry) {
    return Teacher(
      identifier: entry.key,
      name: entry.value,
    );
  }

  MapEntry<String, dynamic> toMapEntry() {
    return MapEntry(identifier, name);
  }
}
