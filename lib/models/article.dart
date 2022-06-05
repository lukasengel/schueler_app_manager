enum ArticleElementType {
  HEADER,
  SUBHEADER,
  CONTENT_HEADER,
  CONTENT,
  IMAGE;

  factory ArticleElementType.fromString(String data) {
    switch (data) {
      case "header":
        return ArticleElementType.HEADER;
      case "subheader":
        return ArticleElementType.SUBHEADER;
      case "content_header":
        return ArticleElementType.CONTENT_HEADER;
      case "image":
        return ArticleElementType.IMAGE;
      default:
        return ArticleElementType.CONTENT;
    }
  }

  String toJson() {
    switch (this) {
      case ArticleElementType.HEADER:
        return "header";
      case ArticleElementType.SUBHEADER:
        return "subheader";
      case ArticleElementType.CONTENT_HEADER:
        return "content_header";
      case ArticleElementType.IMAGE:
        return "image";
      default:
        return "content";
    }
  }
}

class ArticleElement {
  final String data;
  final ArticleElementType type;
  final String? imageCopyright;
  final String? description;
  final bool? dark;

  const ArticleElement({
    required this.data,
    required this.type,
    this.description,
    this.imageCopyright,
    this.dark,
  });

  factory ArticleElement.fromJson(Map<String, dynamic> json) {
    String getString(String key) {
      return json.containsKey(key) ? json[key] as String : "";
    }

    String? tryGetString(String key) {
      return json.containsKey(key) ? json[key] as String : null;
    }

    return ArticleElement(
      data: getString("data"),
      type: ArticleElementType.fromString(getString("type")),
      description: tryGetString("description"),
      imageCopyright: tryGetString("imageCopyright"),
      dark: json.containsKey("dark") ? json["dark"] as bool : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "data": data,
      "type": type.toJson(),
      "description": description,
      "imageCopyright": imageCopyright,
      "dark": dark,
    };
  }
}
