import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './snackbar.dart';

Future<void> executeWithErrorHandling(dynamic arg, Function callback) async {
  try {
    if (arg != null) {
      await callback(arg);
    } else {
      await callback();
    }
  } catch (e) {
    showSnackBar(
      context: Get.context!,
      snackbar: SnackBar(
        content: Text(e.toString()),
        action: SnackBarAction(label: "OK", onPressed: Get.back),
      ),
    );
  }
}
