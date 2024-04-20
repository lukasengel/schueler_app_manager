import 'package:schueler_app_manager/models/models.dart';

enum SchoolLifeItemType {
  EVENT,
  ARTICLE,
  ANNOUNCEMENT;

  factory SchoolLifeItemType.fromString(String data) {
    return SchoolLifeItemType.values.byName(data.toUpperCase());
  }

  @override
  String toString() {
    return name.toLowerCase();
  }
}

class SchoolLifeItem {
  final String identifier;
  final DateTime datetime;
  final String header;
  final String content;
  final String? hyperlink;
  final List<ArticleElement>? articleElements;

  const SchoolLifeItem({
    required this.identifier,
    required this.datetime,
    required this.header,
    required this.content,
    this.hyperlink,
    this.articleElements,
  });

  factory SchoolLifeItem.fromMapEntry(MapEntry<String, dynamic> data) {
    List<ArticleElement>? articleElements;

    if (data.value.containsKey("articleElements")) {
      final elements = data.value["articleElements"];

      if (elements is List) {
        articleElements = elements.map((value) {
          return ArticleElement.fromMap(Map<String, dynamic>.from(value));
        }).toList();
      }
    }

    final SchoolLifeItemType type = SchoolLifeItemType.fromString(data.value["type"]);

    switch (type) {
      case SchoolLifeItemType.EVENT:
        return EventSchoolLifeItem(
          identifier: data.key,
          datetime: DateTime.parse(data.value["datetime"]),
          header: data.value["header"],
          content: data.value["content"],
          hyperlink: data.value["hyperlink"],
          articleElements: articleElements,
          eventTime: DateTime.parse(data.value["eventTime"]),
        );
      case SchoolLifeItemType.ARTICLE:
        return ArticleSchoolLifeItem(
          identifier: data.key,
          datetime: DateTime.parse(data.value["datetime"]),
          header: data.value["header"],
          content: data.value["content"],
          hyperlink: data.value["hyperlink"],
          articleElements: articleElements,
          externalImage: data.value["externalImage"],
          imageUrl: data.value["imageUrl"],
          imageCopyright: data.value["imageCopyright"],
          dark: data.value["dark"],
        );
      case SchoolLifeItemType.ANNOUNCEMENT:
        return SchoolLifeItem(
          identifier: data.key,
          datetime: DateTime.parse(data.value["datetime"]),
          header: data.value["header"],
          content: data.value["content"],
          hyperlink: data.value["hyperlink"],
          articleElements: articleElements,
        );
    }
  }

  MapEntry<String, dynamic> toMapEntry() {
    return MapEntry(identifier, {
      "datetime": datetime.toIso8601String(),
      "header": header,
      "content": content,
      "hyperlink": hyperlink,
      "articleElements": articleElements?.map((e) => e.toMap()).toList(),
      "type": SchoolLifeItemType.ANNOUNCEMENT.toString(),
    });
  }
}

class EventSchoolLifeItem extends SchoolLifeItem {
  final DateTime eventTime;

  const EventSchoolLifeItem({
    required super.identifier,
    required super.datetime,
    required super.header,
    required super.content,
    super.hyperlink,
    super.articleElements,
    required this.eventTime,
  });

  @override
  MapEntry<String, dynamic> toMapEntry() {
    return super.toMapEntry()
      ..value.addAll({
        "eventTime": eventTime.toIso8601String(),
        "type": SchoolLifeItemType.EVENT.toString(),
      });
  }
}

class ArticleSchoolLifeItem extends SchoolLifeItem {
  final bool externalImage;
  final String imageUrl;
  final String? imageCopyright;
  final bool dark;

  const ArticleSchoolLifeItem({
    required super.identifier,
    required super.datetime,
    required super.header,
    required super.content,
    super.hyperlink,
    super.articleElements,
    required this.externalImage,
    required this.imageUrl,
    this.imageCopyright,
    required this.dark,
  });

  @override
  MapEntry<String, dynamic> toMapEntry() {
    return super.toMapEntry()
      ..value.addAll({
        "externalImage": externalImage,
        "imageUrl": imageUrl,
        "imageCopyright": imageCopyright,
        "dark": dark,
        "type": SchoolLifeItemType.ARTICLE.toString(),
      });
  }
}
