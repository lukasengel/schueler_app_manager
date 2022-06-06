import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../edit_page/edit_widgets.dart';
import './article_editor_controller.dart';
import './article_widgets.dart';

import '../../models/article.dart';

Future<ArticleElement?> showArticleEditor({
  ArticleElement? itemToEdit,
  required String path,
}) async {
  Get.put(ArticleEditorController(itemToEdit, path));
  final input = await showDialog(
    barrierDismissible: false,
    context: Get.context!,
    builder: (context) => Dialog(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600, maxWidth: 1000),
        child: ArticleEditor(),
      ),
    ),
  );
  Get.delete<ArticleEditorController>();
  return input is ArticleElement ? input : null;
}

class ArticleEditor extends StatelessWidget {
  ArticleEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ArticleEditorController>(builder: (controller) {
      final edit = controller.itemToEdit != null;
      return ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    splashRadius: 20,
                    icon: const Icon(Icons.arrow_back),
                    onPressed: controller.cancel,
                    tooltip: "tooltips/back".tr,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  "edit_page/${edit ? "edit" : "add"}_item".tr,
                  textAlign: TextAlign.center,
                  style: Get.textTheme.titleMedium,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (edit)
                      IconButton(
                        splashRadius: 20,
                        onPressed: controller.delete,
                        color: Colors.red,
                        icon: const Icon(Icons.delete),
                        tooltip: "tooltips/delete_item".tr,
                      ),
                    Obx(
                      () => IconButton(
                        splashRadius: 20,
                        tooltip: "tooltips/save".tr,
                        icon: const Icon(Icons.done),
                        onPressed: controller.validInput.value
                            ? controller.submit
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 0),
          ArticleDropdownButton(
            value: controller.type.toString(),
            onChanged: controller.changeType,
          ),
          const Divider(height: 0),
          controller.type == ArticleElementType.IMAGE
              ? EditImagePicker(
                  onPressedUpload: controller.updloadImage,
                  onPressedDelete: controller.deleteImage,
                  onChangedImageMode: controller.changeImageMode,
                  controller: controller.imageUrlController,
                  onChangedUrl: (_) => controller.validate(),
                  mode: controller.imageMode,
                )
              : EditContainer(
                  label: controller.type == ArticleElementType.IMAGE
                      ? "article_editor/image_url".tr
                      : "article_editor/text".tr,
                  child: TextField(
                    maxLines:
                        controller.type == ArticleElementType.IMAGE ? 1 : 20,
                    minLines: 1,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => controller.validate(),
                    style: Get.textTheme.bodyMedium,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      contentPadding: EdgeInsets.zero,
                    ),
                    controller: controller.dataController,
                  ),
                ),
          if (controller.type == ArticleElementType.IMAGE)
            Column(
              children: [
                const Divider(height: 0),
                EditContainer(
                  label: "edit_page/image_copyright".tr,
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    style: Get.textTheme.bodyMedium,
                    onChanged: (_) => controller.validate(),
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      contentPadding: EdgeInsets.zero,
                    ),
                    controller: controller.imageCopyrightController,
                  ),
                ),
                const Divider(height: 0),
                EditContainer(
                  label: "article_page/description".tr,
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    style: Get.textTheme.bodyMedium,
                    onChanged: (_) => controller.validate(),
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      contentPadding: EdgeInsets.zero,
                    ),
                    controller: controller.descriptionController,
                  ),
                ),
                const Divider(height: 0),
                EditRadioButton(
                  mode: controller.colorMode,
                  onChanged: controller.changeColorMode,
                )
              ],
            ),
          const SizedBox(height: 5),
          Text(
            "edit_page/required".tr,
            style: Get.textTheme.labelSmall,
          ),
        ],
      );
    });
  }
}
