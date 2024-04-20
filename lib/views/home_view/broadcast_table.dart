import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:schueler_app_manager/common/common.dart';
import 'package:schueler_app_manager/models/models.dart';

class BroadcastTable extends StatelessWidget {
  final List<Broadcast> broadcasts;
  final Function(Broadcast) onDelete;

  const BroadcastTable({
    required this.broadcasts,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          key: const ValueKey("broadcasts_comment"),
          leading: const Icon(Icons.announcement),
          title: Text(AppLocalizations.of(context).translate("broadcasts_comment")),
          subtitle: Text(AppLocalizations.of(context).translate("broadcasts_message")),
          tileColor: Theme.of(context).colorScheme.errorContainer,
          textColor: Theme.of(context).colorScheme.onErrorContainer,
          iconColor: Theme.of(context).colorScheme.onErrorContainer,
        ),
        const Divider(height: 0),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 64),
            itemCount: broadcasts.length,
            separatorBuilder: (context, index) => const Divider(height: 0),
            itemBuilder: (context, index) {
              final broadcast = broadcasts[index];

              return ListTile(
                key: ValueKey(broadcast.identifier),
                title: Text(broadcast.header),
                subtitle: Text(broadcast.content),
                minLeadingWidth: 80,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat.yMd(Localizations.localeOf(context).toString())
                          .addPattern("-")
                          .add_jmv()
                          .format(broadcast.datetime),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      tooltip: AppLocalizations.of(context).translate("delete"),
                      color: Theme.of(context).colorScheme.error,
                      onPressed: () => onDelete(broadcast),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
