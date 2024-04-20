import 'package:flutter/material.dart';

import 'package:schueler_app_manager/common/common.dart';

Future<bool> showConfirmDialog({required BuildContext context, required String title, required String content}) async {
  final input = await showDialog<bool?>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              onPressed: Navigator.of(context).pop,
              child: Text(AppLocalizations.of(context).translate("cancel")),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(AppLocalizations.of(context).translate("confirm")),
            ),
          ],
        );
      });

  return input ?? false;
}
