import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/teacher.dart';

enum InputType { TEACHER, BROADCAST }

Future<dynamic> showInputDialog(InputType type, {Teacher? teacher}) async {
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  final focus = FocusNode();
  final index = type.index;
  focus.requestFocus();
  bool edit = false;

  if (teacher != null) {
    controller1.text = teacher.abbreviation;
    controller2.text = teacher.name;
    edit = true;
  }

  void submit() => Get.back(result: {
        "1": controller1.text,
        "2": controller2.text,
        "cancel": false,
      });

  final input = await Get.dialog(
    Theme(
      data: ThemeData(
        brightness: Get.theme.brightness,
        colorScheme: Get.theme.colorScheme,
      ),
      child: AlertDialog(
        title: Text(
          edit ? "dialogs/$index/title_edit".tr : "dialogs/$index/title".tr,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller1,
              focusNode: focus,
              decoration: InputDecoration(
                hintText: "dialogs/$index/textField1".tr,
              ),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 10),
            TextField(
              controller: controller2,
              decoration: InputDecoration(
                hintText: "dialogs/$index/textField2".tr,
              ),
              onSubmitted: (_) => submit(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: Text("dialogs/cancel".tr.toUpperCase()),
          ),
          TextButton(
            onPressed: submit,
            child: Text("dialogs/$index/action".tr.toUpperCase()),
          ),
        ],
      ),
    ),
  );

  return input ?? {"1": "", "2": "", "cancel": true};
}
