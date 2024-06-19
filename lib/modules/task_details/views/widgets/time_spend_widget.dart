import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/modules/task_details/bloc/task_details_bloc.dart';
import 'package:task_tracker/modules/task_details/bloc/task_details_event.dart';
import 'package:task_tracker/modules/task_details/bloc/task_details_state.dart';

class TimeSpendWidget extends StatelessWidget {
  const TimeSpendWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TaskDetailsBloc taskDetailsBloc = context.read<TaskDetailsBloc>();
    return BlocBuilder<TaskDetailsBloc, TaskDetailsState>(
      bloc: taskDetailsBloc,
      buildWhen: (previous, current) {
        if (current is TaskDetailsTaskTimeLoadedState) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        if (taskDetailsBloc.isTaskTimeLoading) {
          return const SizedBox();
        } else if (taskDetailsBloc.taskTime == null) {
          return const SizedBox();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Time Spend",
              style: theme.textTheme.titleMedium?.apply(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 15),
            BlocBuilder<TaskDetailsBloc, TaskDetailsState>(
                bloc: taskDetailsBloc,
                buildWhen: (previous, current) {
                  if (current is TaskDetailsSpendTimeUpdatedState) {
                    return true;
                  } else {
                    return false;
                  }
                },
                builder: (context, state) {
                  return Text(
                    "${taskDetailsBloc.spendTime.inHours}h : ${(taskDetailsBloc.spendTime.inMinutes % 60)}m : ${(taskDetailsBloc.spendTime.inSeconds % 60)}s",
                    style: theme.textTheme.bodyLarge,
                  );
                }),
            if (!taskDetailsBloc.isTaskCompleted) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  if (taskDetailsBloc.taskTime?.startedFrom == null)
                    _TimerActionButton(
                      icon: Icons.play_circle_fill_rounded,
                      action: "Start",
                      iconColor: theme.colorScheme.onPrimaryContainer,
                      bgColor: theme.colorScheme.primaryContainer,
                      onTap: () =>
                          taskDetailsBloc.add(TaskDetailsStartTaskEvent()),
                    )
                  else
                    _TimerActionButton(
                      icon: Icons.pause_circle_filled_rounded,
                      action: "Pause",
                      iconColor: const Color(0xFF988001),
                      bgColor: const Color(0xFFFFF9D8),
                      onTap: () =>
                          taskDetailsBloc.add(TaskDetailsPauseTaskEvent()),
                    ),
                  const SizedBox(width: 20),
                  _TimerActionButton(
                    icon: Icons.check_circle_rounded,
                    action: "Mark As Completed",
                    iconColor: const Color(0xFF0D5D00),
                    bgColor: const Color(0xFFDDFFDE),
                    onTap: () =>
                        taskDetailsBloc.add(TaskDetailsCloseTaskEvent()),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}

class _TimerActionButton extends StatelessWidget {
  final String action;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final void Function() onTap;
  const _TimerActionButton({
    required this.action,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 40,
          padding: const EdgeInsets.only(left: 10, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 25,
                color: iconColor,
              ),
              const SizedBox(width: 5),
              Text(
                action,
                style: theme.textTheme.labelLarge?.apply(
                  color: iconColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
