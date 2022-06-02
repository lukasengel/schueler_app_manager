import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/school_life_item.dart';
import './edit_page_controller.dart';
import './edit_widgets.dart';

class EditPage extends StatelessWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditPageController());
    final edit = controller.itemToEdit != null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: controller.cancel,
          tooltip: "tooltips/back".tr,
        ),
        centerTitle: false,
        title: Text("edit_page/${edit ? "edit" : "add"}_item".tr),
        actions: [
          if (edit)
            IconButton(
              onPressed: controller.delete,
              color: Colors.red,
              icon: Icon(Icons.delete),
              tooltip: "tooltips/delete_item".tr,
            ),
          Obx(
            () => IconButton(
              tooltip: "tooltips/save".tr,
              icon: Icon(Icons.done),
              onPressed: controller.validInput.value ? controller.submit : null,
            ),
          ),
        ],
      ),
      body: Center(
        child: GetBuilder<EditPageController>(builder: (controller) {
          return ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: ListView(
              children: [
                EditDropdownButton(
                  value: controller.type.toString(),
                  onChanged: controller.changeType,
                ),
                Divider(height: 0),
                EditContainer(
                  label: "edit_page/header".tr,
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => controller.validate(),
                    style: Get.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      contentPadding: EdgeInsets.zero,
                    ),
                    controller: controller.headerController,
                  ),
                ),
                Divider(height: 0),
                EditContainer(
                  label: "edit_page/content".tr,
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => controller.validate(),
                    style: Get.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      contentPadding: EdgeInsets.zero,
                    ),
                    controller: controller.contentController,
                  ),
                ),
                Divider(height: 0),
                EditContainer(
                  label: "edit_page/hyperlink".tr,
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    onChanged: (_) => controller.validate(),
                    style: Get.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      contentPadding: EdgeInsets.zero,
                    ),
                    controller: controller.hyperlinkController,
                  ),
                ),
                if (controller.type == ItemType.ARTICLE)
                  Column(
                    children: [
                      Divider(height: 0),
                      EditImagePicker(
                        controller: controller.imageUrlController,
                        onPressedUpload: controller.updloadImage,
                        onChanged: (_) => controller.validate(),
                      ),
                      Divider(height: 0),
                      EditRadioButton(
                        mode: controller.colorMode,
                        onChanged: controller.changeColorMode,
                      )
                    ],
                  ),
                if (controller.type == ItemType.EVENT)
                  Column(
                    children: [
                      Divider(height: 0),
                      EditDatePicker(
                        datetime: controller.eventTime,
                        changeDate: controller.changeEventTime,
                      ),
                    ],
                  ),
                SizedBox(height: 5),
                Text(
                  "edit_page/required".tr,
                  style: Get.textTheme.labelSmall,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
