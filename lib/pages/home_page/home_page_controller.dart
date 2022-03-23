import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schueler_app_manager/models/teacher.dart';

import '../../controllers/web_data.dart';
import '../../controllers/authentication.dart';

import '../../widgets/snackbar.dart';
import '../../widgets/input_dialog.dart';

class HomePageController extends GetxController {
  final webData = Get.find<WebData>();
  int currentTab = 0;

  void onTappedTabBar(int index) {
    currentTab = index;
    update();
  }

  void onPressedRefresh() async {
    await webData.fetchData();
    update();
  }

  void onPressedChangePassword() {}

  void onPressedAdd() async {
    try {
      if (currentTab == 1) {
        await addTeacher();
      }
      update();
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

  Future<void> addTeacher() async {
    final input = await showInputDialog(InputDialogType.TEACHER);
    final abbreviation = (input["1"] as String).trim();
    final name = (input["2"] as String).trim();
    final canceled = input["cancel"] as bool;

    if (abbreviation.isNotEmpty && name.isNotEmpty) {
      await webData.addTeacher(Teacher(abbreviation, name));
      update();
    } else if (!canceled) {
      throw "error/invalid_input".tr;
    }
  }

  void onPressedBroadcast() async {
    try {
      final input = await showInputDialog(InputDialogType.BROADCAST);
      final header = (input["1"] as String).trim();
      final content = (input["2"] as String).trim();
      final canceled = input["cancel"] as bool;

      if (header.isNotEmpty && content.isNotEmpty) {
        await webData.sendBroadcast(header, content);
        throw ("Rundnachricht versandt!");
      } else if (!canceled) {
        throw "error/invalid_input".tr;
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

  void onPressedEditItem(String identifier) {}

  void onPressedDeleteItem(String identifier) async {
    try {
      await webData.deleteItem(identifier);
      update();
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

  void onPressedLogout() async {
    try {
      await (Get.find<Authentication>().signOut());
      webData.clear();
      Get.offAndToNamed("/login");
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

  void onPressedEditTeacher(String oldAbbreviation) async {
    try {
      final oldName = webData.teachers
          .firstWhere((element) => element.abbreviation == oldAbbreviation)
          .name;
      final input = await showInputDialog(
        InputDialogType.TEACHER,
        teacherToEdit: webData.teachers
            .firstWhere((element) => element.abbreviation == oldAbbreviation),
      );

      final newAbbreviation = (input["1"] as String).trim();
      final newName = (input["2"] as String).trim();
      final canceled = input["cancel"] as bool;

      if (newAbbreviation.isNotEmpty && newName.isNotEmpty) {
        if (oldAbbreviation == newAbbreviation && oldName == newName) {
          throw ("error/no_changes".tr);
        } else {
          await webData.removeTeacher(oldAbbreviation);
          await webData.addTeacher(Teacher(newAbbreviation, newName));
          update();
        }
      } else if (!canceled) {
        throw "error/invalid_input".tr;
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

  void onPressedDeleteTeacher(String abbreviation) async {
    try {
      await webData.removeTeacher(abbreviation);
      update();
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
}
