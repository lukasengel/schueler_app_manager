import 'package:flutter/material.dart';

import 'package:get/get.dart';

ThemeData get _getTheme {
  return ThemeData(
    brightness: Get.theme.brightness,
    colorScheme: Get.theme.colorScheme,
  );
}

Future<bool> showWaitingDialog() async {
  final input = await Get.dialog(
    Theme(
      data: _getTheme,
      child: AlertDialog(
        title: Text(
          "dialog/waiting_header".tr,
          style: const TextStyle(fontSize: 18),
        ),
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 10),
            Text("dialog/waiting_message".tr),
          ],
        ),
      ),
    ),
  );
  return input ?? false;
}
