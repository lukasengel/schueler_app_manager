import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../home_page_controller.dart';

class BroadcastTab extends StatelessWidget {
  const BroadcastTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomePageController>();
    return Center(
      child: controller.webData.broadcasts.isEmpty
          ? Text("home/no_content".tr)
          : ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final broadcast = controller.webData.broadcasts[index];
                  return ListTile(
                    minLeadingWidth: 80,
                    tileColor: Get.theme.colorScheme.tertiary,
                    title: Text(
                      broadcast.header,
                      style: Get.textTheme.bodyMedium,
                    ),
                    subtitle: Text(
                      broadcast.content,
                      style: Get.textTheme.bodySmall,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          DateFormat("dd.MM.yyyy - H:mm")
                              .format(broadcast.datetime),
                          style: Get.textTheme.labelSmall,
                        ),
                        IconButton(
                          splashRadius: 20,
                          icon: const Icon(Icons.remove_circle),
                          color: Colors.red,
                          onPressed: () => controller
                              .onPressedDeleteBroadcast(broadcast.identifier),
                          tooltip: "tooltips/delete_item".tr,
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(height: 0),
                itemCount: controller.webData.broadcasts.length,
              ),
            ),
    );
  }
}
