import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditContainer extends StatelessWidget {
  final String label;
  final Widget child;
  const EditContainer({required this.label, required this.child, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.theme.colorScheme.tertiary,
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: Get.textTheme.labelSmall),
          ),
          Expanded(
            flex: 8,
            child: child,
          ),
        ],
      ),
    );
  }
}

class EditDropdownButton extends StatelessWidget {
  final String value;
  final void Function(String?) onChanged;
  const EditDropdownButton({
    required this.value,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EditContainer(
      label: "edit_page/type".tr,
      child: Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: 150,
          child: DropdownButton<String>(
            focusColor: Colors.transparent,
            icon: const Icon(Icons.arrow_downward),
            isExpanded: true,
            value: value != "null" ? value : null,
            hint: Text("edit_page/select".tr),
            style: Get.textTheme.bodySmall,
            items: [
              DropdownMenuItem(
                child: Text("edit_page/event".tr),
                value: "ItemType.EVENT",
              ),
              DropdownMenuItem(
                child: Text("edit_page/article".tr),
                value: "ItemType.ARTICLE",
              ),
              DropdownMenuItem(
                child: Text("edit_page/announcement".tr),
                value: "ItemType.ANNOUNCEMENT",
              ),
            ],
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}

class EditImagePicker extends StatelessWidget {
  final Function() onPressedUpload;
  final Function() onPressedDelete;

  final Function(String) onChangedImageMode;
  final Function(String)? onChangedUrl;

  final TextEditingController controller;
  final String? mode;

  const EditImagePicker({
    required this.onPressedUpload,
    required this.onPressedDelete,
    required this.onChangedImageMode,
    this.onChangedUrl,
    required this.controller,
    required this.mode,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EditContainer(
          label: "edit_page/image_mode".tr,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(children: [
                Radio(
                  value: "external",
                  groupValue: mode,
                  onChanged: (_) => onChangedImageMode("external"),
                ),
                Text("edit_page/external".tr),
              ]),
              Row(children: [
                Radio(
                  value: "asset",
                  groupValue: mode,
                  onChanged: (_) => onChangedImageMode("asset"),
                ),
                Text("edit_page/asset".tr),
              ]),
            ],
          ),
        ),
        const Divider(height: 0),
        EditContainer(
          label: "edit_page/image_url".tr,
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  enabled: mode == "external",
                  onChanged: onChangedUrl,
                  style: Get.textTheme.bodyMedium,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    contentPadding: EdgeInsets.zero,
                  ),
                  controller: controller,
                ),
              ),
              if (mode == "asset" && controller.text.isEmpty)
                TextButton.icon(
                  onPressed: onPressedUpload,
                  icon: const Icon(Icons.upload),
                  label: Text("edit_page/upload".tr),
                ),
              if (mode == "asset" && controller.text.isNotEmpty)
                TextButton.icon(
                  onPressed: onPressedDelete,
                  icon: const Icon(Icons.close),
                  label: Text("edit_page/delete".tr),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class EditRadioButton extends StatelessWidget {
  final String? mode;
  final Function(String) onChanged;

  const EditRadioButton({required this.mode, required this.onChanged, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EditContainer(
      label: "edit_page/color_mode".tr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(children: [
            Radio(
              value: "light",
              groupValue: mode,
              onChanged: (_) => onChanged("light"),
            ),
            Text("edit_page/light_mode".tr),
          ]),
          Row(children: [
            Radio(
              value: "dark",
              groupValue: mode,
              onChanged: (_) => onChanged("dark"),
            ),
            Text("edit_page/dark_mode".tr),
          ]),
        ],
      ),
    );
  }
}

class EditDatePicker extends StatelessWidget {
  final DateTime? datetime;
  final Function(DateTime) changeDate;

  EditDatePicker({this.datetime, required this.changeDate, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EditContainer(
      label: "edit_page/date".tr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          datetime != null
              ? Text(
                  DateFormat("dd.MM.yyyy").format(datetime!),
                  style: Get.textTheme.bodySmall,
                )
              : Text(
                  "edit_page/no_date_selected".tr,
                  style: Get.textTheme.labelSmall,
                ),
          TextButton.icon(
            label: Text("edit_page/select_date".tr),
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () async {
              final input = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (input != null) {
                changeDate(input);
              }
            },
          ),
        ],
      ),
    );
  }
}

class EditArticle extends StatelessWidget {
  final int elements;
  final Function() editArticle;

  EditArticle({required this.elements, required this.editArticle, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool empty = elements == 0;
    return EditContainer(
      label: "edit_page/text_article".tr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            empty
                ? "edit_page/no_article".tr
                : "$elements" + "edit_page/article_elements".tr,
            style: Get.textTheme.labelSmall,
          ),
          TextButton.icon(
            icon: const Icon(Icons.edit),
            label: Text(
              (empty ? "edit_page/compose_article" : "edit_page/edit_article")
                  .tr,
            ),
            onPressed: editArticle,
          ),
        ],
      ),
    );
  }
}
