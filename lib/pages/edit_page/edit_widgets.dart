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
      padding: EdgeInsets.symmetric(
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
  final Function(String)? onChanged;
  final TextEditingController controller;
  const EditImagePicker({
    this.onChanged,
    required this.controller,
    required this.onPressedUpload,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EditContainer(
      label: "edit_page/image_url".tr,
      child: Row(
        children: [
          Flexible(
            child: TextField(
              onChanged: onChanged,
              style: Get.textTheme.bodyMedium,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                contentPadding: EdgeInsets.zero,
              ),
              controller: controller,
            ),
          ),
          TextButton.icon(
            onPressed: onPressedUpload,
            icon: Icon(Icons.upload),
            label: Text("edit_page/upload".tr),
          ),
        ],
      ),
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
          TextButton(
            child: Text("edit_page/select_date".tr),
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
