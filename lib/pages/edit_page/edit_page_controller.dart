import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/web_data.dart';
import '../../models/school_life_item.dart';
import '../../models/article.dart';

import '../../widgets/confirm_dialog.dart';
import '../../widgets/waiting_dialog.dart';
import '../../widgets/execute_with_error_handling.dart';

import '../article_page/article_page.dart';

class EditPageController extends GetxController {
  final headerController = TextEditingController();
  final contentController = TextEditingController();
  final hyperlinkController = TextEditingController();
  final imageUrlController = TextEditingController();
  final imageCopyrightController = TextEditingController();

  DateTime? eventTime;
  String colorMode = "light";
  ItemType? type;
  SchoolLifeItem? itemToEdit;
  List<ArticleElement>? articleElements;

  List<String?> oldImages = [];
  String? originalImage;
  String? currentImage;
  RxBool validInput = false.obs;

  @override
  void onInit() {
    itemToEdit = Get.arguments;
    if (itemToEdit != null) {
      eventTime = itemToEdit?.eventTime;
      colorMode =
          (itemToEdit!.dark != null && itemToEdit!.dark!) ? "dark" : "light";
      type = itemToEdit?.type;
      headerController.text = itemToEdit?.header ?? "";
      contentController.text = itemToEdit?.content ?? "";
      hyperlinkController.text = itemToEdit?.hyperlink ?? "";
      imageUrlController.text = itemToEdit?.imageUrl ?? "";
      imageCopyrightController.text = itemToEdit?.imageCopyright ?? "";
      originalImage = itemToEdit?.imageUrl;
      currentImage = itemToEdit?.imageUrl;
      articleElements = [...itemToEdit?.articleElements ?? []];
    }
    super.onInit();
  }

  void validate() {
    bool valid = headerController.text.trim().isNotEmpty &&
        contentController.text.trim().isNotEmpty &&
        type != null;
    if (type == ItemType.EVENT) {
      valid = valid && eventTime != null;
    } else if (type == ItemType.ARTICLE) {
      valid = valid && imageUrlController.text.trim().isNotEmpty;
    }
    validInput.value = valid;
  }

  void changeType(String? input) {
    switch (input) {
      case "ItemType.ARTICLE":
        type = ItemType.ARTICLE;
        break;
      case "ItemType.EVENT":
        type = ItemType.EVENT;
        break;
      default:
        type = ItemType.ANNOUNCEMENT;
    }
    validate();
    update();
  }

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
      final url = await Get.find<WebData>().uploadImage(filename, data!);
      if (currentImage != null && url != currentImage) {
        oldImages.add(currentImage);
        currentImage = url;
        imageUrlController.text = url;
      }
    });
    if (Get.isDialogOpen == true) {
      Get.back();
    }
    validate();
  }

  void changeColorMode(String mode) {
    colorMode = mode;
    validate();
    update();
  }

  void changeEventTime(DateTime input) {
    eventTime = input;
    validate();
    update();
  }

  Future<void> editArticle() async {
    final input =
        await Get.to(() => const ArticlePage(), arguments: articleElements);
    if (input is List<ArticleElement>) {
      if (input != articleElements) {
        articleElements = input;
        validate();
      }
      update();
    }
  }

  Future<void> delete() async {
    final input = await showConfirmDialog(ConfirmDialogMode.DELETE);
    if (input) {
      executeWithErrorHandling(itemToEdit!.identifier, (String id) async {
        await Get.find<WebData>().removeSchoolLifeItem(id, currentImage);
        Get.back();
      });
    }
  }

  Future<void> cleanup(bool cancel) async {
    if (cancel) {
      if (currentImage != originalImage) {
        oldImages.add(currentImage);
      }
      oldImages.removeWhere((element) => element == originalImage);
    } else {
      oldImages.removeWhere((element) => element == currentImage);
    }
    showWaitingDialog();
    for (String? element in oldImages) {
      if (element != null) {
        await executeWithErrorHandling(null, () async {
          await Get.find<WebData>().removeImage(element);
        });
      }
    }
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  void submit() async {
    if (validInput.value) {
      final item = SchoolLifeItem(
        identifier:
            itemToEdit?.identifier ?? DateTime.now().hashCode.toString(),
        header: headerController.text,
        content: contentController.text,
        type: type!,
        datetime: DateTime.now(),
        hyperlink: hyperlinkController.text.trim().isNotEmpty
            ? hyperlinkController.text.trim()
            : null,
        imageUrl:
            type == ItemType.ARTICLE ? imageUrlController.text.trim() : null,
        imageCopyright: type == ItemType.ARTICLE &&
                imageCopyrightController.text.trim().isNotEmpty
            ? imageCopyrightController.text.trim()
            : null,
        eventTime: type == ItemType.EVENT ? eventTime : null,
        dark: (type == ItemType.ARTICLE) ? colorMode == "dark" : null,
        articleElements: articleElements ?? [],
      );
      await cleanup(false);
      Get.back(result: item);
    }
  }

  void cancel() async {
    final input = await showConfirmDialog(ConfirmDialogMode.DISCARD);
    if (input) {
      await cleanup(true);
      Get.back();
    }
  }
}
