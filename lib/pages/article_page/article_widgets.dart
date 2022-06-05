import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/article.dart';

class ArticleContainer extends StatelessWidget {
  final ArticleElement element;
  final Function() onDelete;
  final Function() onEdit;

  const ArticleContainer({
    required this.element,
    required this.onDelete,
    required this.onEdit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.theme.colorScheme.tertiary,
      child: InkWell(
        onTap: onEdit,
        child: Column(children: [
          ArticleItem(
            label: "article_page/type".tr,
            text: "article_page/type/${element.type}".tr,
            onDelete: onDelete,
          ),
          const Divider(height: 0),
          ArticleItem(
            label: element.type == ArticleElementType.IMAGE
                ? "article_page/image_url".tr
                : "article_page/text".tr,
            text: element.data,
          ),
          if (element.type == ArticleElementType.IMAGE)
            Column(
              children: [
                const Divider(height: 0),
                ArticleItem(
                  label: "edit_page/image_copyright".tr,
                  text: element.imageCopyright ?? "",
                ),
                const Divider(height: 0),
                ArticleItem(
                  label: "article_page/description".tr,
                  text: element.description ?? "",
                ),
                const Divider(height: 0),
                ArticleItem(
                  label: "edit_page/color_mode".tr,
                  text: element.dark == true
                      ? "edit_page/dark_mode".tr
                      : "edit_page/light_mode".trParams(),
                ),
              ],
            ),
        ]),
      ),
    );
  }
}

class ArticleItem extends StatelessWidget {
  final String label;
  final String text;
  final Function()? onDelete;

  const ArticleItem({
    required this.label,
    required this.text,
    this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 10,
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: Get.textTheme.labelSmall)),
          Expanded(flex: onDelete == null ? 8 : 7, child: Text(text)),
          if (onDelete != null)
            Expanded(
              child: Container(
                alignment: Alignment.topRight,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: onDelete,
                  splashRadius: 20,
                  icon: const Icon(Icons.remove_circle),
                  tooltip: "tooltips/delete_item".tr,
                  color: Colors.red,
                ),
              ),
            )
        ],
      ),
    );
  }
}
