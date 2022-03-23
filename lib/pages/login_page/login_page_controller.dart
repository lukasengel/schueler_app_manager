import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/authentication.dart';

import '../../widgets/snackbar.dart';

class LoginPageController extends GetxController {
  final authentication = Get.find<Authentication>();
  final usernameController = TextEditingController();
  final passwortController = TextEditingController();
  RxBool working = false.obs;
  RxBool obscure = true.obs;

  void toggleVisibility() {
    obscure.value = !obscure.value;
  }

  void onSubmitted(_) => login();

  void onPressedLogin() => login();

  Future<void> login() async {
    working.value = true;
    try {
      await Future.delayed(const Duration(seconds: 1));
      await Get.find<Authentication>()
          .login(usernameController.text, passwortController.text);
      Get.offAndToNamed("/home");
    } catch (e) {
      showSnackBar(
        context: Get.context!,
        snackbar: SnackBar(
          content: Text(e.toString()),
          action: SnackBarAction(label: "OK", onPressed: Get.back),
        ),
      );
    }
    working.value = false;
  }
}
