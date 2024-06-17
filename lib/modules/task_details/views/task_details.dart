import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/common_widgets/common_loader.dart';
import 'package:task_tracker/modules/kanban_board/models/task_model.dart';
import 'package:task_tracker/modules/task_details/bloc/task_details_bloc.dart';
import 'package:task_tracker/modules/task_details/bloc/task_details_event.dart';
import 'package:task_tracker/modules/task_details/bloc/task_details_state.dart';
import 'package:task_tracker/modules/task_details/views/widgets/add_task_form.dart';
import 'package:task_tracker/modules/task_details/views/widgets/comment_section.dart';
import 'package:task_tracker/modules/task_details/views/widgets/time_spend_widget.dart';
import 'package:task_tracker/utils/date_formatter.dart';

import '../config/task_details_screen_config.dart';

class TaskDetailsScreen extends StatelessWidget {
  final TaskDetailsScreenConfig? config;

  const TaskDetailsScreen({this.config, super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          TaskDetailsBloc(screenConfig: config)..add(TaskDetailsIntialEvent()),
      child: const _TaskDetailsScreen(),
    );
  }
}

class _TaskDetailsScreen extends StatelessWidget {
  const _TaskDetailsScreen();

  @override
  Widget build(BuildContext context) {
    TaskDetailsBloc taskDetailsBloc = context.read<TaskDetailsBloc>();

    return BlocConsumer<TaskDetailsBloc, TaskDetailsState>(
        bloc: taskDetailsBloc,
        listener: (BuildContext context, TaskDetailsState state) {
          if (state is TaskDetailsLoaderState) {
            if (state.showLoader) {
              CommonLoader().showLoader(context);
            } else {
              CommonLoader().hideLoader(context);
            }
          }
        },
        buildWhen: (previous, current) {
          if (current is TaskDetailsScreenUpdateState ||
              current is TaskDetailsTaskAddedState) {
            return true;
          }
          return false;
        },
        builder: (BuildContext context, TaskDetailsState state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                taskDetailsBloc.screenConfig?.task == null
                    ? "Add Task"
                    : "Task Details",
              ),
              actions: taskDetailsBloc.screenConfig?.task != null
                  ? [
                      FilledButton.icon(
                        onPressed: () =>
                            taskDetailsBloc.add(TaskDetailsEditTaskEvent()),
                        label:
                            Text(taskDetailsBloc.isEditing ? "Save" : "Edit"),
                        icon: Icon(taskDetailsBloc.isEditing
                            ? Icons.done
                            : Icons.edit),
                      ),
                      const SizedBox(width: 20),
                    ]
                  : [],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (taskDetailsBloc.isEditing ||
                        taskDetailsBloc.screenConfig?.task == null)
                      const AddTaskForm()
                    else
                      const TaskDetailsSection(),
                    if (taskDetailsBloc.screenConfig?.task != null) ...[
                      const SizedBox(height: 35),
                      const TimeSpendWidget(),
                      const Divider(height: 60),
                      const CommentSection(),
                    ],
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class TaskDetailsSection extends StatelessWidget {
  const TaskDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TaskDetailsBloc taskDetailsBloc = context.read<TaskDetailsBloc>();
    TaskModel? task = taskDetailsBloc.screenConfig?.task;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Task Name",
          style: theme.textTheme.titleMedium?.apply(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          task?.content ?? "",
          style: theme.textTheme.titleLarge,
        ),
        if ((task?.description ?? "").isNotEmpty) ...[
          const SizedBox(height: 25),
          _DataSection(
            title: "Description",
            description: task?.description ?? "",
          ),
        ],
        const SizedBox(height: 25),
        _DataSection(
          title: "Due Date",
          description: task?.due?.date != null
              ? DateFormatterUtil.formatedDateTimeFromString(
                  date: task?.due?.date)
              : "__ ___ ____",
        ),
        const SizedBox(height: 25),
        _DataSection(
          title: "Section",
          description:
              taskDetailsBloc.sectionFromId(task?.sectionId ?? "")?.name ?? "",
        ),
      ],
    );
  }
}

class _DataSection extends StatelessWidget {
  final String title;
  final String description;
  const _DataSection({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium
              ?.apply(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 5),
        Text(
          description,
          style: theme.textTheme.bodyMedium?.apply(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}