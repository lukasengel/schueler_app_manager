import 'package:flutter/material.dart';

import 'package:schueler_app_manager/common/common.dart';
import 'package:schueler_app_manager/models/models.dart';

class TeacherDialog extends StatefulWidget {
  final Teacher? initial;

  const TeacherDialog(this.initial, {super.key});

  @override
  State<TeacherDialog> createState() => _TeacherDialogState();
}

class _TeacherDialogState extends State<TeacherDialog> {
  final _abbreviationController = TextEditingController();
  final _nameController = TextEditingController();
  var _valid = false;

  @override
  void initState() {
    if (widget.initial != null) {
      _abbreviationController.text = widget.initial!.identifier;
      _nameController.text = widget.initial!.name;
      _validate();
    }
    super.initState();
  }

  @override
  void dispose() {
    _abbreviationController.dispose();
    _nameController.dispose();

    super.dispose();
  }

  void _validate() {
    setState(() {
      _valid = _abbreviationController.text.trim().isNotEmpty && _nameController.text.trim().isNotEmpty;
    });
  }

  void _onSave() {
    final result = Teacher(
      identifier: _abbreviationController.text.trim(),
      name: _nameController.text.trim(),
    );

    Navigator.of(context).pop(result);
  }

  void _onCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context).translate(widget.initial == null ? "newTeacher" : "editTeacher"),
      ),
      actions: [
        TextButton(
          onPressed: _onCancel,
          child: Text(
            AppLocalizations.of(context).translate("cancel"),
          ),
        ),
        FilledButton(
          onPressed: _valid ? _onSave : null,
          child: Text(
            AppLocalizations.of(context).translate("save"),
          ),
        ),
      ],
      content: Container(
        width: 400,
        constraints: const BoxConstraints(
          maxHeight: 600,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: _abbreviationController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).translate("abbreviation"),
              ),
              onChanged: (input) => _validate(),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).translate("name"),
              ),
              onChanged: (input) => _validate(),
              onSubmitted: (input) => _valid ? _onSave() : null,
            ),
          ],
        ),
      ),
    );
  }
}
