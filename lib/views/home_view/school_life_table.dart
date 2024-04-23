import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:schueler_app_manager/common/common.dart';
import 'package:schueler_app_manager/models/models.dart';

class SchoolLifeTable extends StatelessWidget {
  final List<SchoolLifeItem> schoolLifeItems;
  final Function(SchoolLifeItem) onEdit;
  final Function(SchoolLifeItem) onDelete;

  const SchoolLifeTable({
    required this.schoolLifeItems,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: schoolLifeItems.length,
      separatorBuilder: (context, index) => const Divider(height: 0),
      itemBuilder: (context, index) {
        final schoolLifeItem = schoolLifeItems[index];

        return ListTile(
          key: ValueKey(schoolLifeItem.identifier),
          title: Text(schoolLifeItem.header),
          subtitle: Text(schoolLifeItem.content),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat.yMd(Localizations.localeOf(context).toString())
                    .addPattern("-")
                    .add_jmv()
                    .format(schoolLifeItem.datetime),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
              const SizedBox(width: 5),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                tooltip: AppLocalizations.of(context).translate("delete"),
                color: Theme.of(context).colorScheme.error,
                onPressed: () => onDelete(schoolLifeItem),
              ),
            ],
          ),
          onTap: () => onEdit(schoolLifeItem),
        );
      },
    );
  }
}
