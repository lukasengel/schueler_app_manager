enum ArticleElementType {
  HEADER,
  SUBHEADER,
  CONTENT_HEADER,
  CONTENT,
  IMAGE;

  factory ArticleElementType.fromString(String data) {
    return ArticleElementType.values.byName(data.toUpperCase());
  }

  @override
  String toString() {
    return name.toLowerCase();
  }
}

class ArticleElement {
  final ArticleElementType type;
  final String data;

  const ArticleElement({
    required this.type,
    required this.data,
  });

  factory ArticleElement.fromMap(Map<String, dynamic> data) {
    final ArticleElementType type = ArticleElementType.fromString(data["type"]);

    switch (type) {
      case ArticleElementType.HEADER:
      case ArticleElementType.SUBHEADER:
      case ArticleElementType.CONTENT_HEADER:
      case ArticleElementType.CONTENT:
        return ArticleElement(
          type: type,
          data: data["data"],
        );
      case ArticleElementType.IMAGE:
        return ImageArticleElement(
          data: data["data"],
          externalImage: data["externalImage"],
          dark: data["dark"],
          imageCopyright: data["imageCopyright"],
          description: data["description"],
        );
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "type": type.toString(),
      "data": data,
    };
  }
}

class ImageArticleElement extends ArticleElement {
  final bool externalImage;
  final bool dark;
  final String? imageCopyright;
  final String? description;

  const ImageArticleElement({
    required super.data,
    required this.externalImage,
    required this.dark,
    this.imageCopyright,
    this.description,
  }) : super(type: ArticleElementType.IMAGE);

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        "externalImage": externalImage,
        "dark": dark,
        "imageCopyright": imageCopyright,
        "description": description,
      });
  }
}
