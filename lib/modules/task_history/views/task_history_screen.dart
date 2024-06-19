import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_tracker/config/routes/app_routes.dart';
import 'package:task_tracker/modules/kanban_board/views/task_card.dart';
import 'package:task_tracker/modules/task_details/config/task_details_screen_config.dart';
import 'package:task_tracker/modules/task_history/bloc/task_history_bloc.dart';
import 'package:task_tracker/modules/task_history/bloc/task_history_event.dart';
import 'package:task_tracker/modules/task_history/bloc/task_history_state.dart';

import '../../kanban_board/views/task_card_loading.dart';

class TaskHistoryScreen extends StatelessWidget {
  const TaskHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskHistoryBloc()..add(TaskHistoryIntialEvent()),
      child: const _TaskHistoryScreen(),
    );
  }
}

class _TaskHistoryScreen extends StatelessWidget {
  const _TaskHistoryScreen();

  @override
  Widget build(BuildContext context) {
    final TaskHistoryBloc taskHistoryBloc = context.read<TaskHistoryBloc>();
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Completed Task"),
      ),
      body: BlocConsumer<TaskHistoryBloc, TaskHistoryState>(
          listener: (context, state) {
        if (state is TaskHistoryScreenErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      }, builder: (context, state) {
        if (taskHistoryBloc.isTaskLoading) {
          return ListView.builder(
            itemCount: 4,
            itemBuilder: (context, index) => const TaskCardLoading(),
          );
        }

        if (taskHistoryBloc.taskList.isEmpty) {
          return Center(
              child: Text(
            "Competed Task Not Found",
            style: theme.textTheme.headlineSmall,
          ));
        }

        return ListView.builder(
          itemCount: taskHistoryBloc.taskList.length,
          padding: const EdgeInsets.symmetric(vertical: 20),
          itemBuilder: (context, index) {
            return TaskCard(
              task: taskHistoryBloc.taskList[index],
              onTap: () => context.push(
                AppRoutes.taskDetails,
                extra: TaskDetailsScreenConfig(
                  task: taskHistoryBloc.taskList[index],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
