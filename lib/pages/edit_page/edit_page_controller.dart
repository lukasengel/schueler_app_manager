import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../controllers/web_data.dart';

import '../../models/school_life_item.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/execute_with_error_handling.dart';

class EditPageController extends GetxController {
  final headerController = TextEditingController();
  final contentController = TextEditingController();
  final hyperlinkController = TextEditingController();
  final imageUrlController = TextEditingController();
  DateTime? eventTime;
  String colorMode = "light";
  ItemType? type;
  SchoolLifeItem? itemToEdit;

  String? uploadUrl;
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
      uploadUrl = itemToEdit?.imageUrl;
    }
    super.onInit();
  }

  void validate() {
    bool valid = headerController.text.isNotEmpty &&
        contentController.text.isNotEmpty &&
        type != null;
    if (type == ItemType.EVENT) {
      valid = valid && eventTime != null;
    } else if (type == ItemType.ARTICLE) {
      valid = valid && imageUrlController.text.isNotEmpty;
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

  void updloadImage() async {
    executeWithErrorHandling(null, () async {
      final selection = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image,
      );
      if (selection == null) {
        throw ("error/no_selection".tr);
      }
      final filename = selection.files.single.name;
      final data = selection.files.single.bytes;
      if (uploadUrl != null) {
        await Get.find<WebData>().removeImage(uploadUrl!);
        uploadUrl = null;
      }
      final url = await Get.find<WebData>().uploadImage(filename, data!);
      uploadUrl = url;
      imageUrlController.text = url;
    });
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

  void delete() async {
    final input = await showConfirmDialog(ConfirmDialogMode.DELETE);
    if (!input) {
      return;
    }
    executeWithErrorHandling(itemToEdit!.identifier, (String id) async {
      await Get.find<WebData>().removeSchoolLifeItem(id, uploadUrl);
      Get.back();
    });
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
        eventTime: type == ItemType.EVENT ? eventTime : null,
        dark: (type == ItemType.ARTICLE) ? colorMode == "dark" : null,
      );
      Get.back(result: item);
    }
  }

  void cancel() async {
    final input = await showConfirmDialog(ConfirmDialogMode.DISCARD);

    if (input) {
      if (uploadUrl != null) {
        executeWithErrorHandling(null, () async {
          await Get.find<WebData>().removeImage(uploadUrl!);
        });
      }
      Get.back();
    }
  }
}
