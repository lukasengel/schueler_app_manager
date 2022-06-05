import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/credentials.dart';
import '../../pages/home_page/home_page.dart';
import '../../controllers/authentication.dart';

import '../../widgets/execute_with_error_handling.dart';

class LoginPageController extends GetxController {
  final authentication = Get.find<Authentication>();
  final usernameController = TextEditingController();
  final passwortController = TextEditingController();
  RxBool working = false.obs;
  RxBool obscure = true.obs;

  void toggleVisibility() {
    obscure.value = !obscure.value;
  }

  void clear() {
    obscure.value = true;
    usernameController.clear();
    passwortController.clear();
  }

  Future<void> login() async {
    working.value = true;
    await executeWithErrorHandling(null, () async {
      await authentication.login(
        usernameController.text,
        passwortController.text,
      );
      authentication.session = Credentials(
        usernameController.text.trim(),
        passwortController.text.trim(),
      );
      Get.off(() => const HomePage());
      clear();
    });
    working.value = false;
  }
}
