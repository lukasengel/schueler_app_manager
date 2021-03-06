import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home_page_controller.dart';

class TeachersTab extends StatelessWidget {
  TeachersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomePageController>();
    return Center(
      child: controller.webData.teachers.isEmpty
          ? Text("home/no_content".tr)
          : ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final teacher = controller.webData.teachers[index];
                  return ListTile(
                    onTap: () =>
                        controller.onPressedEditTeacher(teacher.abbreviation),
                    minLeadingWidth: 80,
                    tileColor: context.theme.colorScheme.tertiary,
                    leading: Text(
                      teacher.abbreviation,
                      style: Get.textTheme.titleMedium,
                    ),
                    title: Text(
                      teacher.name,
                      style: Get.textTheme.bodyMedium,
                    ),
                    trailing: IconButton(
                      splashRadius: 20,
                      icon: const Icon(Icons.remove_circle),
                      color: Colors.red,
                      onPressed: () => controller
                          .onPressedDeleteTeacher(teacher.abbreviation),
                      tooltip: "tooltips/delete_item".tr,
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(height: 0),
                itemCount: controller.webData.teachers.length,
              ),
            ),
    );
  }
}
