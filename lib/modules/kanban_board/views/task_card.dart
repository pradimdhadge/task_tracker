import 'package:flutter/material.dart';
import 'package:task_tracker/modules/kanban_board/models/task_model.dart';
import 'package:task_tracker/utils/date_formatter.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final Widget? dragHandler;
  final void Function() onTap;
  const TaskCard(
      {required this.task, required this.onTap, this.dragHandler, super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              offset: const Offset(0, 4),
              color: theme.colorScheme.primaryContainer.withOpacity(0.5),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    task.content ?? "",
                    style: theme.textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                dragHandler ?? const SizedBox()
              ],
            ),
            if ((task.description ?? "").isNotEmpty) ...[
              const SizedBox(height: 5),
              Text(
                task.description ?? "",
                style: theme.textTheme.bodyMedium?.apply(
                  color: theme.colorScheme.outline,
                ),
              )
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      size: 15,
                      color: theme.colorScheme.tertiary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      task.createdAt != null
                          ? DateFormatterUtil.formatedDateTimeFromString(
                              date: task.createdAt)
                          : "",
                      style: theme.textTheme.bodyMedium?.apply(
                        color: theme.colorScheme.tertiary,
                      ),
                    )
                  ],
                ),
                const SizedBox(width: 15),
                if ((task.due?.date ?? "").isNotEmpty)
                  Row(
                    children: [
                      Icon(
                        Icons.flag_outlined,
                        size: 15,
                        color: theme.colorScheme.tertiary,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        DateFormatterUtil.formatedDateTimeFromString(
                            date: task.due?.date),
                        style: theme.textTheme.bodyMedium?.apply(
                          color: theme.colorScheme.tertiary,
                        ),
                      )
                    ],
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}
