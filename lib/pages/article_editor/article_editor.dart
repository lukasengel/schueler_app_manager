import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:schueler_app_manager/models/article.dart';

import './article_editor_controller.dart';

import '../edit_page/edit_widgets.dart';
import './article_widgets.dart';

class ArticleEditor extends StatelessWidget {
  const ArticleEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ArticleEditorController());
    final edit = controller.itemToEdit != null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: controller.cancel,
          tooltip: "tooltips/back".tr,
        ),
        centerTitle: false,
        title: Text("edit_page/${edit ? "edit" : "add"}_item".tr),
        actions: [
          if (edit)
            IconButton(
              onPressed: controller.delete,
              color: Colors.red,
              icon: const Icon(Icons.delete),
              tooltip: "tooltips/delete_item".tr,
            ),
          Obx(
            () => IconButton(
              tooltip: "tooltips/save".tr,
              icon: const Icon(Icons.done),
              onPressed: controller.validInput.value ? controller.submit : null,
            ),
          ),
        ],
      ),
      body: Center(
        child: GetBuilder<ArticleEditorController>(builder: (controller) {
          return ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: ListView(
              children: [
                ArticleDropdownButton(
                  value: controller.type.toString(),
                  onChanged: controller.changeType,
                ),
                const Divider(height: 0),
                EditContainer(
                  label: controller.type == ArticleElementType.IMAGE
                      ? "article_editor/image_url".tr
                      : "article_editor/text".tr,
                  child: TextField(
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
            ),
          );
        }),
      ),
    );
  }
}
