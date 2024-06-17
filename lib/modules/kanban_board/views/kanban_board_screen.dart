import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_tracker/common_widgets/common_shimmer.dart';
import 'package:task_tracker/config/routes/app_routes.dart';
import 'package:task_tracker/modules/kanban_board/bloc/kanban_board_bloc.dart';
import 'package:task_tracker/modules/kanban_board/bloc/kanban_board_event.dart';
import 'package:task_tracker/modules/kanban_board/bloc/kanban_board_state.dart';
import 'package:task_tracker/modules/kanban_board/views/task_card_loading.dart';
import 'package:task_tracker/modules/task_details/config/task_details_screen_config.dart';

import 'task_card.dart';

class KanbanBoard extends StatelessWidget {
  const KanbanBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          KanbanBoardBloc(KanbanBoardState())..add(KanbanBoardInitialEvent()),
      child: const _KanbanBoard(),
    );
  }
}

class _KanbanBoard extends StatelessWidget {
  const _KanbanBoard();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    KanbanBoardBloc kanbanBoardBloc = context.read<KanbanBoardBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Task"),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.taskHistory),
            icon: const Icon(Icons.history_rounded),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.color_lens_rounded),
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<KanbanBoardBloc, KanbanBoardState>(
        bloc: kanbanBoardBloc,
        buildWhen: (previous, current) {
          if (current is KanbanBoardSectionUpdated) {
            return true;
          }
          return false;
        },
        builder: (BuildContext context, _) {
          if (kanbanBoardBloc.sections.isEmpty) return const SizedBox();

          return FloatingActionButton(
            isExtended: true,
            shape: const CircleBorder(),
            onPressed: () => context.push(
              AppRoutes.taskDetails,
              extra: TaskDetailsScreenConfig(
                  sections: kanbanBoardBloc.sections,
                  currentSection: kanbanBoardBloc.sections[0]),
            ),
            child: const Icon(Icons.add),
          );
        },
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 5),
          BlocBuilder<KanbanBoardBloc, KanbanBoardState>(
            buildWhen: (previous, current) {
              if (current is KanbanBoardSectionUpdated ||
                  current is KanbanBoardErrorState) {
                return true;
              }
              return false;
            },
            builder: (BuildContext context, KanbanBoardState state) {
              return SizedBox(
                height: 50,
                child: kanbanBoardBloc.isSectionLoading
                    ? const SectionLoading()
                    : ListView.builder(
                        itemCount: kanbanBoardBloc.sections.length + 1,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 15, right: 20),
                        itemBuilder: (context, index) {
                          if (kanbanBoardBloc.sections.length == index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              key: GlobalKey(),
                              child: FilledButton.tonalIcon(
                                onPressed: () {},
                                icon: const Icon(Icons.add),
                                label: const Text("Add Section"),
                              ),
                            );
                          }
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            key: GlobalKey(),
                            child: FilledButton(
                              onPressed: () {},
                              child: Text(
                                kanbanBoardBloc.sections[index].name ?? "",
                              ),
                            ),
                          );
                        },
                      ),
              );
            },
          ),
          const SizedBox(height: 25),
          Expanded(
              child: BlocBuilder<KanbanBoardBloc, KanbanBoardState>(
            buildWhen: (previous, current) {
              if (current is KanbanBoardLoadingState ||
                  current is KanbanBoardTaskUpdatedState) {
                return true;
              } else {
                return false;
              }
            },
            builder: (BuildContext context, KanbanBoardState state) {
              if (kanbanBoardBloc.isTaskLoading) {
                return ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) => const TaskCardLoading(),
                );
              } else if (kanbanBoardBloc.allTasks.isEmpty) {
                return Center(
                  child: Text(
                    "No Task Found",
                    style: theme.textTheme.headlineSmall?.apply(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              }
              return ReorderableListView.builder(
                buildDefaultDragHandles: false,
                itemCount: kanbanBoardBloc.allTasks.length,
                itemBuilder: (context, index) {
                  return TaskCard(
                    key: GlobalKey(),
                    onTap: () => context.push(
                      AppRoutes.taskDetails,
                      extra: TaskDetailsScreenConfig(
                        task: kanbanBoardBloc.allTasks[index],
                        sections: kanbanBoardBloc.sections,
                        currentSection: kanbanBoardBloc.sectionFromId(
                          kanbanBoardBloc.allTasks[index].sectionId ?? "",
                        ),
                      ),
                    ),
                    task: kanbanBoardBloc.allTasks[index],
                    dragHandler: ReorderableDragStartListener(
                      index: index,
                      child: Icon(
                        Icons.reorder_outlined,
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  );
                },
                onReorder: (oldIndex, newIndex) {},
              );
            },
          ))
        ],
      ),
    );
  }
}

class SectionLoading extends StatelessWidget {
  const SectionLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 15, right: 20),
      itemBuilder: (context, index) {
        return CommonShimmer(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: const ShimmerGrayBox(
              height: 40,
              width: 120,
              radius: 20,
            ),
          ),
        );
      },
      itemCount: 2,
    );
  }
}
