enum ItemType { EVENT, ARTICLE, ANNOUNCEMENT }

ItemType typeFromString(String string) {
  switch (string) {
    case "event":
      return ItemType.EVENT;
    case "article":
      return ItemType.ARTICLE;
    default:
      return ItemType.ANNOUNCEMENT;
  }
}

String stringFromType(ItemType type) {
  switch (type) {
    case ItemType.EVENT:
      return "event";
    case ItemType.ARTICLE:
      return "article";
    default:
      return "announcement";
  }
}

class SchoolLifeItem {
  String identifier;
  String header;
  String content;
  ItemType type;
  DateTime datetime;
  String? hyperlink;
  String? imageUrl;
  DateTime? eventTime;
  bool? dark;

  SchoolLifeItem({
    required this.identifier,
    required this.header,
    required this.content,
    required this.type,
    required this.datetime,
    this.hyperlink,
    this.imageUrl,
    this.eventTime,
    this.dark,
  });

  factory SchoolLifeItem.fromJson(Map<String, dynamic> json, String id) {
    String getString(String key) {
      return json.containsKey(key) ? json[key] as String : "";
    }

    return SchoolLifeItem(
      identifier: id,
      header: getString("header"),
      content: getString("content"),
      type: typeFromString(json["type"]),
      datetime: DateTime.tryParse(getString("datetime")) ?? DateTime.now(),
      hyperlink: getString("hyperlink"),
      imageUrl: getString("imageUrl"),
      eventTime: DateTime.tryParse(getString("eventTime")),
      dark: json.containsKey("dark") ? json["dark"] as bool : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "header": header,
      "content": content,
      "type": stringFromType(type),
      "datetime": datetime.toIso8601String(),
      "hyperlink": hyperlink,
      "imageUrl": imageUrl,
      "eventTime": eventTime?.toIso8601String(),
      "dark": dark,
    };
  }
}
