import 'package:flutter/material.dart';

import 'package:get/get.dart';

enum ConfirmDialogMode { DISCARD, DELETE }

ThemeData get _getTheme {
  return ThemeData(
    brightness: Get.theme.brightness,
    colorScheme: Get.theme.colorScheme,
  );
}

Future<bool> showConfirmDialog(ConfirmDialogMode mode) async {
  final index = mode.index;
  final input = await Get.dialog(
    Theme(
      data: _getTheme,
      child: AlertDialog(
        title: Text("dialog/${index}/confirm_header".tr,
            style: const TextStyle(fontSize: 18)),
        content: Text("dialog/${index}/confirm_message".tr),
        buttonPadding: const EdgeInsets.all(20),
        actions: <Widget>[
          TextButton(
            child: Text("dialog/cancel".tr.tr.toUpperCase()),
            onPressed: Get.back,
          ),
          TextButton(
            child: Text("dialog/${index}/confirm_action".tr.toUpperCase()),
            onPressed: () => Get.back(result: true),
          ),
        ],
      ),
    ),
  );
  return input ?? false;
}
