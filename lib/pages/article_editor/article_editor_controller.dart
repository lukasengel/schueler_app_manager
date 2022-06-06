import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

import '../../controllers/web_data.dart';
import '../../pages/article_page/article_page_controller.dart';

import '../../models/article.dart';

import '../../widgets/confirm_dialog.dart';
import '../../widgets/waiting_dialog.dart';
import '../../widgets/execute_with_error_handling.dart';

class ArticleEditorController extends GetxController {
  ArticleElement? itemToEdit;
  String path;
  ArticleEditorController(this.itemToEdit, this.path);

  final dataController = TextEditingController();
  final imageUrlController = TextEditingController();
  final descriptionController = TextEditingController();
  final imageCopyrightController = TextEditingController();

  String imageMode = "external";
  String colorMode = "light";
  ArticleElementType? type;

  String? originalData;
  String? externalImage;
  RxBool validInput = false.obs;
  int? index;

  @override
  void onInit() {
    if (itemToEdit != null) {
      index = Get.find<ArticlePageController>()
          .articleElements
          .indexOf(itemToEdit!);
      final item = itemToEdit!;

      type = item.type;
      if (type == ArticleElementType.IMAGE) {
        imageUrlController.text = item.data;
      } else {
        dataController.text = item.data;
      }
      descriptionController.text = item.description ?? "";
      imageCopyrightController.text = item.imageCopyright ?? "";
      colorMode = (item.dark != null && item.dark!) ? "dark" : "light";
      imageMode = item.externalImage == false ? "asset" : "external";
    }
    super.onInit();
  }

  void validate() {
    if (type == ArticleElementType.IMAGE) {
      validInput.value = imageUrlController.text.trim().isNotEmpty;
    } else {
      validInput.value = dataController.text.trim().isNotEmpty && type != null;
    }
    update();
  }

// ###################################################################################
// #                                Edit Functions                                   #
// ###################################################################################

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
  }

  void changeColorMode(String mode) {
    colorMode = mode;
    validate();
  }

  void changeImageMode(String mode) {
    if (imageMode == "asset" && imageUrlController.text.isNotEmpty) {
      return;
    }
    imageMode = mode;
    if (mode == "asset") {
      externalImage = imageUrlController.text;
      imageUrlController.clear();
    } else {
      imageUrlController.text = externalImage ?? "";
    }
    validate();
  }

// ###################################################################################
// #                                  Image Actions                                  #
// ###################################################################################

  Future<void> updloadImage() async {
    await executeWithErrorHandling(null, () async {
      final selection = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image,
      );
      if (selection == null) {
        throw ("error/no_selection".tr);
      }
      final filename = selection.files.single.name;
      final data = selection.files.single.bytes;
      showWaitingDialog();
      final url =
          await Get.find<WebData>().uploadImage(filename, "$path", data!);
      dataController.text = url;
    });
    if (Get.isDialogOpen == true) {
      Get.back();
    }
    validate();
  }

  Future<void> deleteImage() async {
    await executeWithErrorHandling(null, () async {
      showWaitingDialog();
      await Get.find<WebData>().removeImage(dataController.text);
      dataController.clear();
    });
    if (Get.isDialogOpen == true) {
      Get.back();
    }
    validate();
  }

// ###################################################################################
// #                                AppBar Actions                                   #
// ###################################################################################

  Future<void> submit() async {
    if (validInput.value) {
      final item = ArticleElement(
        data: type == ArticleElementType.IMAGE
            ? imageUrlController.text.trim()
            : dataController.text.trim(),
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
      if (imageMode == "asset") {
        await deleteImage();
      }
      Get.back();
    }
  }
}
