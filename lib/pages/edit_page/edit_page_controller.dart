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
  String imageMode = "external";
  ItemType? type;
  List<ArticleElement>? articleElements;

  RxBool canCancel = true.obs;
  String? externalImage;
  RxBool validInput = false.obs;

  late bool edit;
  late String identifier;

  @override
  void onInit() {
    final itemToEdit = Get.arguments;
    if (itemToEdit is SchoolLifeItem) {
      edit = true;
      identifier = itemToEdit.identifier;
      eventTime = itemToEdit.eventTime;
      colorMode = itemToEdit.dark == true ? "dark" : "light";
      type = itemToEdit.type;
      headerController.text = itemToEdit.header;
      contentController.text = itemToEdit.content;
      hyperlinkController.text = itemToEdit.hyperlink ?? "";
      imageUrlController.text = itemToEdit.imageUrl ?? "";
      imageCopyrightController.text = itemToEdit.imageCopyright ?? "";
      articleElements = [...itemToEdit.articleElements];
      imageMode = itemToEdit.externalImage == true ? "external" : "asset";
    } else {
      edit = false;
      identifier = DateTime.now().hashCode.toString();
    }
    super.onInit();
  }

  void validate() {
    bool valid = headerController.text.trim().isNotEmpty &&
        contentController.text.trim().isNotEmpty &&
        type != null;
    valid = valid && validateUrl(hyperlinkController.text);
    if (type == ItemType.EVENT) {
      valid = valid && eventTime != null;
    } else if (type == ItemType.ARTICLE) {
      valid = valid && imageUrlController.text.trim().isNotEmpty;
    }
    validInput.value = valid;
  }

  bool validateUrl(input) {
    return input.isEmpty ||
        input.startsWith("http://") ||
        input.startsWith("https://");
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
      final url = await Get.find<WebData>().uploadImage(
        filename,
        identifier,
        data!,
      );
      imageUrlController.text = url;
    });
    if (Get.isDialogOpen == true) {
      Get.back();
    }
    validate();
    update();
  }

  Future<void> deleteImage() async {
    await executeWithErrorHandling(null, () async {
      showWaitingDialog();
      await Get.find<WebData>().removeImage(imageUrlController.text);
      imageUrlController.clear();
    });
    if (Get.isDialogOpen == true) {
      Get.back();
    }
    validate();
    update();
  }

  void changeColorMode(String mode) {
    colorMode = mode;
    validate();
    update();
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
    update();
  }

  void changeEventTime(DateTime input) {
    eventTime = input;
    validate();
    update();
  }

  Future<void> editArticle() async {
    final input = await Get.to(
      () => const ArticlePage(),
      arguments: {"path": identifier, "elements": articleElements},
    );
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
      await executeWithErrorHandling(identifier, (String id) async {
        showWaitingDialog();
        await Get.find<WebData>().removeSchoolLifeItem(id, true);
        Get.back();
      });
    }
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  Future<void> submit() async {
    if (validInput.value) {
      final item = SchoolLifeItem(
        identifier: identifier,
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
        externalImage:
            type == ItemType.ARTICLE ? imageMode == "external" : null,
        eventTime: type == ItemType.EVENT ? eventTime : null,
        dark: (type == ItemType.ARTICLE) ? colorMode == "dark" : null,
        articleElements: articleElements ?? [],
      );
      Get.back(result: item);
    }
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
