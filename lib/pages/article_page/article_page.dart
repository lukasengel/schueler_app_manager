import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../edit_page/edit_page_controller.dart';

import './article_page_controller.dart';
import './article_widgets.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ArticlePageController());

    return Scaffold(
      appBar: AppBar(
        leading: Obx(() => IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: Get.find<EditPageController>().canCancel.value
                  ? controller.cancel
                  : null,
              tooltip: "tooltips/back".tr,
            )),
        centerTitle: false,
        title: Text("edit_page/compose_article".tr),
        actions: [
          IconButton(
            onPressed: controller.help,
            icon: const Icon(Icons.help),
            tooltip: "tooltips/help".tr,
          ),
          IconButton(
            tooltip: "tooltips/save".tr,
            icon: const Icon(Icons.done),
            onPressed: controller.submit,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        onPressed: controller.addItem,
        label: Text("home/add_element".tr),
      ),
      body: Center(
        child: GetBuilder<ArticlePageController>(builder: (controller) {
          return ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: ListView.separated(
              itemBuilder: (context, index) {
                return ArticleContainer(
                  element: controller.articleElements[index],
                  onDelete: () => controller.deleteItem(index),
                  onEdit: () => controller.editItem(index),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemCount: controller.articleElements.length,
            ),
          );
        }),
      ),
    );
  }
}
