import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/confirm_dialog.dart';
import '../../models/article.dart';
import '../article_editor/article_editor.dart';

class ArticlePageController extends GetxController {
  late List<ArticleElement> articleElements = [];
  late String path;

  @override
  void onInit() {
    final Map args = Get.arguments;
    path = args["path"];
    if (args["elements"] != null) {
      articleElements = [...args["elements"]];
    }
    super.onInit();
  }

  Future<void> addItem() async {
    final input = await showArticleEditor(path: path);
    if (input is ArticleElement) {
      articleElements.add(input);
      update();
    }
  }

  Future<void> editItem(int index) async {
    final input =
        await showArticleEditor(itemToEdit: articleElements[index], path: path);
    if (input is ArticleElement) {
      articleElements.removeAt(index);
      articleElements.insert(index, input);
      update();
    }
  }

  Future<void> deleteItem(int index) async {
    final input = await showConfirmDialog(ConfirmDialogMode.DELETE);
    if (input) {
      articleElements.removeAt(index);
      update();
    }
  }

  Future<void> cancel() async {
    final input = await showConfirmDialog(ConfirmDialogMode.DISCARD);
    if (input) {
      Get.back();
    }
  }

  Future<void> help() async {
    Get.dialog(Theme(
      data: ThemeData(
        brightness: Get.theme.brightness,
        colorScheme: Get.theme.colorScheme,
      ),
      child: AlertDialog(
        content: Image.asset("assets/images/elements.png"),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text("OK"),
          )
        ],
      ),
    ));
  }

  void submit() {
    Get.back(result: articleElements);
  }
}
