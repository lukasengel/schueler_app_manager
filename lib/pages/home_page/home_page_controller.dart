import 'package:get/get.dart';

import '../../pages/login_page/login_page.dart';
import '../../pages/edit_page/edit_page.dart';

import '../../controllers/web_data.dart';
import '../../controllers/authentication.dart';

import '../../widgets/confirm_dialog.dart';
import '../../widgets/input_dialog.dart';
import '../../widgets/waiting_dialog.dart';
import '../../widgets/execute_with_error_handling.dart';

import '../../models/credentials.dart';
import '../../models/teacher.dart';
import '../../models/school_life_item.dart';

class HomePageController extends GetxController {
  final webData = Get.find<WebData>();
  int currentTab = 0;

  // ###################################################################################
  // #                                BUTTON ACTIONS                                   #
  // ###################################################################################

  void onTappedTabBar(int index) {
    currentTab = index;
    update();
  }

  void onPressedRefresh() {
    executeWithErrorHandling(null, () async {
      await webData.fetchData();
      update();
    });
  }

  void onPressedLogout() {
    executeWithErrorHandling(null, () async {
      await (Get.find<Authentication>().signOut());
      webData.clear();
      Get.off(const LoginPage());
    });
  }

  void onPressedChangePassword() async {
    final auth = Get.find<Authentication>();

    await executeWithErrorHandling(null, () async {
      await webData.testWriteAccess();

      Map input = await showInputDialog(InputType.OLD_PASSWORD);
      final oldCredentials = Credentials(input["1"], input["2"]);

      if (oldCredentials.isNotEmpty) {
        await auth.signOut();
        await auth.login(oldCredentials.username, oldCredentials.password);

        input = await showInputDialog(InputType.NEW_PASSWORT);
        String newPassword = input["1"];

        if (newPassword.isNotEmpty) {
          showWaitingDialog();
          await auth.changePassword(newPassword);
          await auth.signOut();

          await auth.login(auth.session.username, auth.session.password);
          await webData.changePassword(newPassword);
          throw ("home/change_password_success".tr);
        }
      }
      throw ("error/invalid_input".tr);
    });

    await auth.signOut();
    await auth.login(auth.session.username, auth.session.password);
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  // ###################################################################################
  // #                                      ADD                                        #
  // ###################################################################################

  void onPressedAdd() {
    executeWithErrorHandling(null, () async {
      switch (currentTab) {
        case 1:
          await addTeacher();
          break;
        case 2:
          await sendBroadcast();
          break;
        default:
          await addItem();
      }
      update();
    });
  }

  Future<void> addItem() async {
    final input = await Get.to(() => const EditPage());
    if (input is SchoolLifeItem) {
      await webData.addSchoolLifeItem(input);
    }
  }

  Future<void> addTeacher() async {
    final input = await showInputDialog(InputType.TEACHER);
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

  Future<void> sendBroadcast() async {
    final input = await showInputDialog(InputType.BROADCAST);
    final header = (input["1"] as String).trim();
    final content = (input["2"] as String).trim();
    final canceled = input["cancel"] as bool;
    if (header.isNotEmpty && content.isNotEmpty) {
      await webData.sendBroadcast(header, content);
      update();
      throw ("home/sent_broadcast".tr);
    } else if (!canceled) {
      throw "error/invalid_input".tr;
    }
  }

  // ###################################################################################
  // #                                      EDIT                                       #
  // ###################################################################################

  void onPressedEditItem(String identifier) async {
    executeWithErrorHandling(null, () async {
      if (identifier.startsWith("item")) {
        throw ("error/write_protection".tr);
      }
      final itemToEdit = webData.schoolLifeItems.firstWhere((element) {
        return element.identifier == identifier;
      });
      final input = await Get.to(() => const EditPage(), arguments: itemToEdit);
      if (input is SchoolLifeItem) {
        await webData.removeSchoolLifeItem(identifier, false);
        await webData.addSchoolLifeItem(input);
      }
      update();
    });
  }

  void onPressedEditTeacher(String abbreviation) {
    executeWithErrorHandling(abbreviation, (String oldAbbreviation) async {
      final oldTeacher = webData.teachers.firstWhere((element) {
        return element.abbreviation == oldAbbreviation;
      });
      final input =
          await showInputDialog(InputType.TEACHER, teacher: oldTeacher);
      final newAbbreviation = (input["1"] as String).trim();
      final newName = (input["2"] as String).trim();
      final canceled = input["cancel"] as bool;
      if (newAbbreviation.isNotEmpty && newName.isNotEmpty) {
        if (oldAbbreviation == newAbbreviation && oldTeacher.name == newName) {
          throw ("error/no_changes".tr);
        } else {
          await webData.removeTeacher(oldAbbreviation);
          await webData.addTeacher(Teacher(newAbbreviation, newName));
          update();
        }
      } else if (!canceled) {
        throw "error/invalid_input".tr;
      }
    });
  }

  // ###################################################################################
  // #                                     DELETE                                      #
  // ###################################################################################

  void onPressedDeleteItem(String identifier) async {
    final input = await showConfirmDialog(ConfirmDialogMode.DELETE);
    if (input) {
      await executeWithErrorHandling(identifier, (String id) async {
        showWaitingDialog();
        await webData.removeSchoolLifeItem(id, true);
        update();
      });
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    }
  }

  void onPressedDeleteTeacher(String abbreviation) async {
    final input = await showConfirmDialog(ConfirmDialogMode.DELETE);
    if (!input) {
      return;
    }
    executeWithErrorHandling(abbreviation, (String abbr) async {
      await webData.removeTeacher(abbreviation);
      update();
    });
  }

  void onPressedDeleteBroadcast(int identifier) async {
    final input = await showConfirmDialog(ConfirmDialogMode.DELETE);
    if (!input) {
      return;
    }
    executeWithErrorHandling(identifier, (int id) async {
      await webData.removeBroadcast(identifier);
      update();
    });
  }
}
