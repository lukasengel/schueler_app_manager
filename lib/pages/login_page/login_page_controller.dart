import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../pages/home_page/home_page.dart';
import '../../controllers/authentication.dart';
import '../../controllers/web_data.dart';

import '../../widgets/execute_with_error_handling.dart';
import '../../widgets/input_dialog.dart';
import '../../widgets/waiting_dialog.dart';

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
    working.value = false;
    obscure.value = true;
    usernameController.clear();
    passwortController.clear();
  }

  Future<void> login() async {
    working.value = true;
    await executeWithErrorHandling(null, () async {
      await Future.delayed(const Duration(seconds: 1));
      await authentication.login(
          usernameController.text, passwortController.text);
      Get.off(() => HomePage());
      clear();
    });

    working.value = false;
  }

  void onPressedChangePassword() async {
    await executeWithErrorHandling(null, () async {
      Map input = await showInputDialog(InputType.ADMIN_PASSWORD);
      String adminUsername = input["1"];
      String adminPassword = input["2"];

      if (adminUsername.isNotEmpty && adminPassword.isNotEmpty) {
        await authentication.login(adminUsername, adminPassword);
        await Get.find<WebData>().testWriteAccess();
        await authentication.signOut();

        input = await showInputDialog(InputType.OLD_PASSWORD);
        String oldUsername = input["1"];
        String oldPassword = input["2"];

        if (oldUsername.isNotEmpty && oldPassword.isNotEmpty) {
          await authentication.login(oldUsername, oldPassword);
          input = await showInputDialog(InputType.NEW_PASSWORT);
          String newPassword = input["1"];

          if (newPassword.isNotEmpty) {
            showWaitingDialog();
            await authentication.changePassword(newPassword);
            await authentication.signOut();
            await authentication.login(adminUsername, adminPassword);
            await Get.find<WebData>().changePassword(newPassword);
            throw ("login/change_password_success".tr);
          }
        }
      }
      throw ("error/invalid_input".tr);
    });
    await authentication.signOut();
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }
}
