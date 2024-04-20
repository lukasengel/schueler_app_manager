import 'package:flutter/material.dart';

import 'package:schueler_app_manager/common/common.dart';
import 'package:schueler_app_manager/models/models.dart';

class TeacherTable extends StatelessWidget {
  final List<Teacher> teachers;
  final Function(Teacher) onEdit;
  final Function(Teacher) onDelete;

  const TeacherTable({
    required this.teachers,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: teachers.length,
      separatorBuilder: (context, index) => const Divider(height: 0),
      itemBuilder: (context, index) {
        final teacher = teachers[index];

        return ListTile(
          key: ValueKey(teacher.identifier),
          title: Text(teacher.name),
          minLeadingWidth: 80,
          leading: Text(
            teacher.identifier,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            tooltip: AppLocalizations.of(context).translate("delete"),
            color: Theme.of(context).colorScheme.error,
            onPressed: () => onDelete(teacher),
          ),
          onTap: () => onEdit(teacher),
        );
      },
    );
  }
}
