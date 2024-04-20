import 'package:flutter/material.dart';

import 'package:schueler_app_manager/common/common.dart';
import 'package:schueler_app_manager/models/models.dart';

class FeedbackTable extends StatelessWidget {
  final List<FeedbackItem> feedbacks;
  final Function(FeedbackItem) onDelete;

  const FeedbackTable({
    required this.feedbacks,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: feedbacks.length,
      separatorBuilder: (context, index) => const Divider(height: 0),
      itemBuilder: (context, index) {
        final feedback = feedbacks[index];

        return ExpansionTile(
          key: ValueKey(feedback.identifier),
          title: Text(feedback.message),
          trailing: IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            tooltip: AppLocalizations.of(context).translate("delete"),
            color: Theme.of(context).colorScheme.error,
            onPressed: () => onDelete(feedback),
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.centerLeft,
          collapsedShape: const Border(),
          shape: const Border(),
          childrenPadding: feedback.name != null || feedback.email != null ? const EdgeInsets.all(15) : EdgeInsets.zero,
          children: [
            if (feedback.name != null) Text("${AppLocalizations.of(context).translate("name")}: ${feedback.name}"),
            if (feedback.name != null && feedback.email != null) const SizedBox(height: 10),
            if (feedback.email != null) Text("${AppLocalizations.of(context).translate("email")}: ${feedback.email}"),
          ],
        );
      },
    );
  }
}
