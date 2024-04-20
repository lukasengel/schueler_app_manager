import 'package:flutter/material.dart';

import 'package:schueler_app_manager/common/common.dart';
import 'package:schueler_app_manager/models/models.dart';

class BroadcastDialog extends StatefulWidget {
  const BroadcastDialog({super.key});

  @override
  State<BroadcastDialog> createState() => _BroadcastDialogState();
}

class _BroadcastDialogState extends State<BroadcastDialog> {
  final _headerController = TextEditingController();
  final _contentController = TextEditingController();
  var _valid = false;

  @override
  void dispose() {
    _headerController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _validate() {
    setState(() {
      _valid = _headerController.text.trim().isNotEmpty && _contentController.text.trim().isNotEmpty;
    });
  }

  void _onCancel() {
    Navigator.of(context).pop();
  }

  void _onSave() {
    final dateTime = DateTime.now();

    final result = Broadcast(
      identifier: dateTime.hashCode.toString(),
      header: _headerController.text.trim(),
      content: _contentController.text.trim(),
      datetime: dateTime,
    );

    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).translate("newBroadcast")),
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
              controller: _headerController,
              maxLength: 40,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).translate("header"),
              ),
              onChanged: (input) => _validate(),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _contentController,
              maxLength: 100,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).translate("content"),
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
