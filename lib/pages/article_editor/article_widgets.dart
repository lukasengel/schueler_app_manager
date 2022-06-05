import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../edit_page/edit_widgets.dart';

class ArticleDropdownButton extends StatelessWidget {
  final String value;
  final void Function(String?) onChanged;
  const ArticleDropdownButton({
    required this.value,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EditContainer(
      label: "edit_page/type".tr,
      child: Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: 150,
          child: DropdownButton<String>(
            focusColor: Colors.transparent,
            icon: const Icon(Icons.arrow_downward),
            isExpanded: true,
            value: value != "null" ? value : null,
            hint: Text("edit_page/select".tr),
            style: Get.textTheme.bodySmall,
            items: [
              DropdownMenuItem(
                child: Text("article_page/type/ArticleElementType.HEADER".tr),
                value: "ArticleElementType.HEADER",
              ),
              DropdownMenuItem(
                child:
                    Text("article_page/type/ArticleElementType.SUBHEADER".tr),
                value: "ArticleElementType.SUBHEADER",
              ),
              DropdownMenuItem(
                child: Text(
                    "article_page/type/ArticleElementType.CONTENT_HEADER".tr),
                value: "ArticleElementType.CONTENT_HEADER",
              ),
              DropdownMenuItem(
                child: Text("article_page/type/ArticleElementType.CONTENT".tr),
                value: "ArticleElementType.CONTENT",
              ),
              DropdownMenuItem(
                child: Text("article_page/type/ArticleElementType.IMAGE".tr),
                value: "ArticleElementType.IMAGE",
              ),
            ],
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}

class ArticleImagePicker extends StatelessWidget {
  final Function() onPressedUpload;
  final Function(String)? onChanged;
  final TextEditingController controller;
  const ArticleImagePicker({
    this.onChanged,
    required this.controller,
    required this.onPressedUpload,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EditContainer(
      label: "edit_page/image_url".tr,
      child: Row(
        children: [
          Flexible(
            child: TextField(
              onChanged: onChanged,
              style: Get.textTheme.bodyMedium,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                contentPadding: EdgeInsets.zero,
              ),
              controller: controller,
            ),
          ),
          // TextButton.icon(
          //   onPressed: onPressedUpload,
          //   icon: const Icon(Icons.upload),
          //   label: Text("edit_page/upload".tr),
          // ),
        ],
      ),
    );
  }
}
