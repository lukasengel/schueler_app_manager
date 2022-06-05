import 'package:flutter/material.dart';

import 'package:get/get.dart';

ThemeData get _getTheme {
  return ThemeData(
    brightness: Get.theme.brightness,
    colorScheme: Get.theme.colorScheme,
  );
}

void showWaitingDialog() {
  Get.dialog(
    Theme(
      data: _getTheme,
      child: AlertDialog(
        title: Text(
          "dialog/waiting_header".tr,
          style: const TextStyle(fontSize: 18),
        ),
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 10),
            Text("dialog/waiting_message".tr),
          ],
        ),
      ),
    ),
  );
}
