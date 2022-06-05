import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../pages/article_page/article_page_controller.dart';

import '../../models/article.dart';

import '../../widgets/confirm_dialog.dart';

class ArticleEditorController extends GetxController {
  final dataController = TextEditingController();
  final descriptionController = TextEditingController();
  final imageCopyrightController = TextEditingController();

  String colorMode = "light";
  ArticleElementType? type;

  List<String?> oldImages = [];
  String? originalImage;
  String? currentImage;
  RxBool validInput = false.obs;

  int? index;
  ArticleElement? itemToEdit;

  @override
  void onInit() {
    itemToEdit = Get.arguments;
    if (itemToEdit != null) {
      index = Get.find<ArticlePageController>()
          .articleElements
          .indexOf(itemToEdit!);
      final item = itemToEdit!;

      type = item.type;
      dataController.text = item.data;
      descriptionController.text = item.description ?? "";
      imageCopyrightController.text = item.imageCopyright ?? "";
      colorMode = (item.dark != null && item.dark!) ? "dark" : "light";
    }
    super.onInit();
  }

  void validate() {
    validInput.value = dataController.text.trim().isNotEmpty && type != null;
  }

  void changeType(String? input) {
    switch (input) {
      case "ArticleElementType.HEADER":
        type = ArticleElementType.HEADER;
        break;
      case "ArticleElementType.SUBHEADER":
        type = ArticleElementType.SUBHEADER;
        break;
      case "ArticleElementType.CONTENT_HEADER":
        type = ArticleElementType.CONTENT_HEADER;
        break;
      case "ArticleElementType.IMAGE":
        type = ArticleElementType.IMAGE;
        break;
      default:
        type = ArticleElementType.CONTENT;
    }
    validate();
    update();
  }

  void changeColorMode(String mode) {
    colorMode = mode;
    validate();
    update();
  }

// ###################################################################################
// #                                AppBar Actions                                   #
// ###################################################################################

  Future<void> submit() async {
    if (validInput.value) {
      final item = ArticleElement(
        data: dataController.text,
        description: type == ArticleElementType.IMAGE &&
                imageCopyrightController.text.trim().isNotEmpty
            ? descriptionController.text
            : null,
        type: type!,
        imageCopyright: type == ArticleElementType.IMAGE &&
                imageCopyrightController.text.trim().isNotEmpty
            ? imageCopyrightController.text.trim()
            : null,
        dark: (type == ArticleElementType.IMAGE) ? colorMode == "dark" : null,
      );
      Get.back(result: item);
    }
  }

  Future<void> delete() async {
    await Get.find<ArticlePageController>().deleteItem(index!);
    Get.back();
  }

  Future<void> cancel() async {
    final input = await showConfirmDialog(ConfirmDialogMode.DISCARD);
    if (input) {
      Get.back();
    }
  }
}
