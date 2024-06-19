import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_tracker/modules/task_details/bloc/task_details_bloc.dart';

import '../../bloc/task_details_event.dart';
import '../delete_task_modal.dart';

class MoreActionWidget extends PopupMenuEntry<Never> {
  final TaskDetailsBloc taskDetailsBloc;
  const MoreActionWidget({required this.taskDetailsBloc, super.key});

  @override
  State<MoreActionWidget> createState() => _MoreActionWidgetState();

  @override
  double get height => 200;

  @override
  bool represents(void value) => false;
}

class _MoreActionWidgetState extends State<MoreActionWidget> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface,
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MenuWidget(
            title: "Mark as completed",
            icon: Icons.done_all_rounded,
            onTap: () {
              context.pop();
              widget.taskDetailsBloc.add(TaskDetailsCloseTaskEvent());
            },
          ),
          MenuWidget(
            title: "Delete Task",
            icon: Icons.delete,
            onTap: () async {
              context.pop();
              final bool res = await DeleteTaskModal.show(
                      context: context,
                      title: "Are you sure?",
                      body:
                          "This will delete the task permanently. You can not undo this action.") ??
                  false;
              if (res) {
                widget.taskDetailsBloc.add(TaskDetailsDeleteTaskEvent());
              }
            },
          ),
        ],
      ),
    );
  }
}

class MenuWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function() onTap;
  const MenuWidget(
      {required this.title,
      required this.icon,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 10),
              Text(
                title,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
