import './article.dart';

enum ItemType {
  EVENT,
  ARTICLE,
  ANNOUNCEMENT;

  factory ItemType.fromString(String data) {
    switch (data) {
      case "event":
        return ItemType.EVENT;
      case "article":
        return ItemType.ARTICLE;
      default:
        return ItemType.ANNOUNCEMENT;
    }
  }

  String toJson() {
    switch (this) {
      case ItemType.EVENT:
        return "event";
      case ItemType.ARTICLE:
        return "article";
      default:
        return "announcement";
    }
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
  String? imageCopyright;
  DateTime? eventTime;
  bool? dark;
  List<ArticleElement> articleElements;

  SchoolLifeItem({
    required this.identifier,
    required this.header,
    required this.content,
    required this.type,
    required this.datetime,
    this.hyperlink,
    this.imageUrl,
    this.imageCopyright,
    this.eventTime,
    this.dark,
    this.articleElements = const [],
  });

  factory SchoolLifeItem.fromJson(Map<String, dynamic> json, String id) {
    String getString(String key) {
      return json.containsKey(key) ? json[key] as String : "";
    }

    String? tryGetString(String key) {
      return json.containsKey(key) ? json[key] as String : null;
    }

    List<ArticleElement>? articleElements = [];

    if (json.containsKey("articleElements")) {
      final elements = json["articleElements"];
      if (elements is List) {
        elements.forEach((value) {
          articleElements.add(ArticleElement.fromJson(
            Map<String, dynamic>.from(value),
          ));
        });
      }
    }

    return SchoolLifeItem(
      identifier: id,
      header: getString("header"),
      content: getString("content"),
      type: ItemType.fromString(getString("type")),
      datetime: DateTime.tryParse(getString("datetime")) ?? DateTime.now(),
      hyperlink: tryGetString("hyperlink"),
      imageUrl: tryGetString("imageUrl"),
      imageCopyright: tryGetString("imageCopyright"),
      eventTime: DateTime.tryParse(tryGetString("eventTime") ?? ""),
      dark: json.containsKey("dark") ? json["dark"] as bool : null,
      articleElements: articleElements,
    );
  }

  Map<String, dynamic> toJson() {
    print(articleElements);
    return {
      "header": header,
      "content": content,
      "type": type.toJson(),
      "datetime": datetime.toIso8601String(),
      "hyperlink": hyperlink,
      "imageUrl": imageUrl,
      "imageCopyright": imageCopyright,
      "eventTime": eventTime?.toIso8601String(),
      "dark": dark,
      "articleElements": articleElements.isNotEmpty
          ? articleElements.map((e) => e.toJson()).toList()
          : null,
    };
  }
}
