import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../home_page_controller.dart';

class SchoolLifeTab extends StatelessWidget {
  const SchoolLifeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomePageController>();
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: ListView.separated(
          itemBuilder: (context, index) {
            final item = controller.webData.schoolLifeItems[index];
            return ListTile(
              onTap: () => controller.onPressedEditItem(item.identifier),
              minLeadingWidth: 80,
              tileColor: Colors.white,
              title: Text(
                item.header,
                style: Get.textTheme.bodyMedium,
              ),
              subtitle: Text(
                item.content,
                style: Get.textTheme.bodySmall,
              ),
              trailing: IconButton(
                splashRadius: 20,
                icon: const Icon(Icons.remove_circle),
                color: Colors.red,
                onPressed: () =>
                    controller.onPressedDeleteItem(item.identifier),
                tooltip: "tooltips/delete_item".tr,
              ),
            );
          },
          separatorBuilder: (context, index) => Divider(height: 0),
          itemCount: controller.webData.schoolLifeItems.length,
        ),
      ),
    );
  }
}
