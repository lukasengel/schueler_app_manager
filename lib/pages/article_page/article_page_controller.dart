import 'package:get/get.dart';

import '../../widgets/confirm_dialog.dart';
import '../../models/article.dart';

import '../article_editor/article_editor.dart';

class ArticlePageController extends GetxController {
  late List<ArticleElement> articleElements;

  @override
  void onInit() {
    articleElements = [...Get.arguments];
    super.onInit();
  }

  Future<void> addItem() async {
    final input = await Get.to(() => const ArticleEditor());
    if (input is ArticleElement) {
      articleElements.add(input);
      update();
    }
  }

  Future<void> editItem(int index) async {
    final input = await Get.to(() => const ArticleEditor(),
        arguments: articleElements[index]);
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

  void submit() {
    Get.back(result: articleElements);
  }
}
