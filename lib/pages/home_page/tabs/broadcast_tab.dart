import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../home_page_controller.dart';

class BroadcastTab extends StatelessWidget {
  BroadcastTab({Key? key}) : super(key: key);

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
                    tileColor: context.theme.colorScheme.tertiary,
                    minLeadingWidth: 80,
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
                separatorBuilder: (context, index) => const Divider(height: 0),
                itemCount: controller.webData.broadcasts.length,
              ),
            ),
    );
  }
}
