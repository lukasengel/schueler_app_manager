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
  String hyperlink;
  String imageUrl;
  DateTime eventTime;
  bool dark;

  SchoolLifeItem({
    required this.identifier,
    required this.header,
    required this.content,
    required this.type,
    required this.datetime,
    required this.hyperlink,
    required this.imageUrl,
    required this.eventTime,
    required this.dark,
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
      eventTime: DateTime.tryParse(getString("eventTime")) ?? DateTime.now(),
      dark: json.containsKey("dark") ? json["dark"] as bool : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "header": header,
      "content": content,
      "type": stringFromType(type),
      "datetime": datetime,
      "hyperlink": hyperlink,
      "imageUrl": imageUrl,
      "eventTime": eventTime,
      "dark": dark,
    };
  }
}
