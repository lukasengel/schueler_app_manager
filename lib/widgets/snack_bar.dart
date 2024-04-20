import 'package:flutter/material.dart';

import 'package:schueler_app_manager/common/common.dart';

void showSnackBar({
  required BuildContext context,
  required Widget content,
  SnackBarAction? action,
  Duration? duration,
}) {
  // Close all open snackbars
  ScaffoldMessenger.of(context).clearSnackBars();
  // Show new snackbar
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: duration ?? const Duration(seconds: 5),
      content: content,
      action: action ??
          SnackBarAction(
            label: AppLocalizations.of(context).translate("dismiss").toUpperCase(),
            onPressed: ScaffoldMessenger.of(context).clearSnackBars,
          ),
    ),
  );
}

void showErrorSnackBar({
  required BuildContext context,
  required Object error,
  Duration? duration,
}) {
  showSnackBar(
    context: context,
    duration: duration ?? const Duration(seconds: 10),
    content: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "${AppLocalizations.of(context).translate("error").toUpperCase()}: ",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Flexible(
          child: Text(
            error.toString(),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    ),
  );
}

Future<void> executeWithErrorSnackbar(
  BuildContext context, {
  required Future Function() function,
}) async {
  try {
    await function();
  } catch (e) {
    if (context.mounted) {
      showErrorSnackBar(
        context: context,
        error: e,
      );
    }
  }
}
