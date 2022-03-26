import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  Future<void> login() async {
    working.value = true;
    await executeWithErrorHandling(null, () async {
      await Future.delayed(const Duration(seconds: 1));
      await Get.find<Authentication>()
          .login(usernameController.text, passwortController.text);
      Get.off(() => HomePage());
    });
    working.value = false;
  }
}
