import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_tracker/common_widgets/common_loader.dart';
import 'package:task_tracker/common_widgets/common_shimmer.dart';
import 'package:task_tracker/config/routes/app_routes.dart';
import 'package:task_tracker/modules/kanban_board/bloc/kanban_board_bloc.dart';
import 'package:task_tracker/modules/kanban_board/bloc/kanban_board_event.dart';
import 'package:task_tracker/modules/kanban_board/bloc/kanban_board_state.dart';
import 'package:task_tracker/modules/kanban_board/models/task_model.dart';
import 'package:task_tracker/modules/kanban_board/views/create_section_modal.dart';
import 'package:task_tracker/modules/kanban_board/views/section_setting_modal.dart';
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
    KanbanBoardBloc kanbanBoardBloc = context.read<KanbanBoardBloc>();
    ThemeData theme = Theme.of(context);

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
          if (current is KanbanBoardSectionUpdatedState) {
            return true;
          }
          return false;
        },
        builder: (BuildContext context, _) {
          if (kanbanBoardBloc.sections.isEmpty) return const SizedBox();

          return FloatingActionButton(
            isExtended: true,
            shape: const CircleBorder(),
            onPressed: () async {
              final result = await context.push(
                AppRoutes.taskDetails,
                extra: TaskDetailsScreenConfig(
                    sections: kanbanBoardBloc.activeSections,
                    currentSection: kanbanBoardBloc.activeSectionIndex != 0
                        ? kanbanBoardBloc
                            .sections[kanbanBoardBloc.activeSectionIndex]
                        : null),
              );

              if (result is TaskModel) {
                kanbanBoardBloc.add(KanbanBoardCreateTaskEvent(result));
              }
            },
            child: const Icon(Icons.add),
          );
        },
      ),
      body: BlocListener<KanbanBoardBloc, KanbanBoardState>(
        bloc: kanbanBoardBloc,
        listener: (context, state) {
          if (state is KanbanBoardLoaderState) {
            if (state.showLoader) {
              CommonLoader().showLoader(context);
            } else {
              CommonLoader().hideLoader(context);
            }
          } else if (state is KanbanBoardErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: theme.textTheme.bodyMedium?.apply(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
                backgroundColor: theme.colorScheme.errorContainer,
              ),
            );
          }
        },
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 5),
            SectionPart(),
            SizedBox(height: 25),
            Expanded(child: TaskPart())
          ],
        ),
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

class SectionPart extends StatelessWidget {
  const SectionPart({super.key});

  @override
  Widget build(BuildContext context) {
    KanbanBoardBloc kanbanBoardBloc = context.read<KanbanBoardBloc>();

    return BlocBuilder<KanbanBoardBloc, KanbanBoardState>(
      bloc: kanbanBoardBloc,
      buildWhen: (previous, current) {
        if (current is KanbanBoardSectionUpdatedState ||
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
                          onPressed: () => CreateSectionModal.show(
                              context: context,
                              kanbanBoardBloc: kanbanBoardBloc),
                          icon: const Icon(Icons.add),
                          label: const Text("Add Section"),
                        ),
                      );
                    }
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      key: GlobalKey(),
                      child: kanbanBoardBloc.activeSectionIndex == index
                          ? FilledButton(
                              onPressed: () {},
                              onLongPress: () {
                                if (index != 0) {
                                  SectionSettingModal.show(
                                    context: context,
                                    section: kanbanBoardBloc.sections[index],
                                    kanbanBoardBloc: kanbanBoardBloc,
                                  );
                                }
                              },
                              child: Text(
                                kanbanBoardBloc.sections[index].name ?? "",
                              ),
                            )
                          : OutlinedButton(
                              onPressed: () {
                                kanbanBoardBloc.pageController.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.linearToEaseOut,
                                );
                              },
                              onLongPress: () {
                                if (index != 0) {
                                  SectionSettingModal.show(
                                    context: context,
                                    section: kanbanBoardBloc.sections[index],
                                    kanbanBoardBloc: kanbanBoardBloc,
                                  );
                                }
                              },
                              child: Text(
                                kanbanBoardBloc.sections[index].name ?? "",
                              ),
                            ),
                    );
                  },
                ),
        );
      },
    );
  }
}

class TaskPart extends StatelessWidget {
  const TaskPart({super.key});

  @override
  Widget build(BuildContext context) {
    KanbanBoardBloc kanbanBoardBloc = context.read<KanbanBoardBloc>();
    ThemeData theme = Theme.of(context);

    return BlocBuilder<KanbanBoardBloc, KanbanBoardState>(
      buildWhen: (previous, current) {
        if (current is KanbanBoardLoadingState ||
            current is KanbanBoardTaskUpdatedState) {
          return true;
        } else {
          return false;
        }
      },
      builder: (BuildContext context, KanbanBoardState state) {
        if (kanbanBoardBloc.isSectionLoading) {
          return ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) => const TaskCardLoading(),
          );
        }
        return PageView.builder(
          controller: kanbanBoardBloc.pageController,
          itemCount: kanbanBoardBloc.sections.length,
          onPageChanged: (value) =>
              kanbanBoardBloc.add(KanbanBoardOnPageChangeEvent(value)),
          itemBuilder: (context, index) {
            if (kanbanBoardBloc.isTaskLoading) {
              return ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) => const TaskCardLoading(),
              );
            }
            List<TaskModel> tasks = kanbanBoardBloc.getFilteredTasks(index);
            if (tasks.isEmpty) {
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
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  key: GlobalKey(),
                  onTap: () async {
                    final result = await context.push(
                      AppRoutes.taskDetails,
                      extra: TaskDetailsScreenConfig(
                        task: tasks[index],
                        sections: kanbanBoardBloc.activeSections,
                        currentSection: tasks[index].sectionId != null
                            ? kanbanBoardBloc.sectionFromId(
                                tasks[index].sectionId!,
                              )
                            : null,
                      ),
                    );

                    kanbanBoardBloc.add(KanbanBoardUpdateTaskEvent(
                        updatedData: result, currentTask: tasks[index]));
                  },
                  task: tasks[index],
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
        );
      },
    );
  }
}
