import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/common_widgets/dropdown_list_widget.dart';
import 'package:task_tracker/common_widgets/input_field.dart';
import 'package:task_tracker/modules/task_details/bloc/task_details_bloc.dart';
import 'package:task_tracker/modules/task_details/bloc/task_details_event.dart';
import 'package:task_tracker/modules/task_details/bloc/task_details_state.dart';
import 'package:task_tracker/utils/date_formatter.dart';

class AddTaskForm extends StatelessWidget {
  const AddTaskForm({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final TaskDetailsBloc taskDetailsBloc = context.read<TaskDetailsBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: "Task Name",
          minLines: 1,
          maxLines: 2,
          controller: TextEditingController(text: taskDetailsBloc.taskName),
          onChanged: (value) =>
              taskDetailsBloc.add(TaskDetailsTaskNameUpdateEvent(value)),
        ),
        const SizedBox(height: 25),
        CustomTextField(
          label: "Description",
          controller: TextEditingController(text: taskDetailsBloc.description),
          onChanged: (value) => taskDetailsBloc.description = value,
          minLines: 2,
          maxLines: 2,
        ),
        const SizedBox(height: 25),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () =>
                    taskDetailsBloc.add(TaskDetailsOnTapDuedateEvent(context)),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Due Date",
                        style: theme.textTheme.bodySmall
                            ?.apply(color: theme.colorScheme.primary),
                      ),
                      const SizedBox(height: 5),
                      BlocBuilder<TaskDetailsBloc, TaskDetailsState>(
                        buildWhen: (previous, current) {
                          if (current is TaskDetailsDuedateUpdateState) {
                            return true;
                          } else {
                            return false;
                          }
                        },
                        builder: (context, state) {
                          return Text(
                            taskDetailsBloc.dueDate != null
                                ? DateFormatterUtil
                                    .formatedDateTimeFromDateTime(
                                        date: taskDetailsBloc.dueDate!)
                                : "__ ___ ____",
                            style: theme.textTheme.bodyLarge,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: BlocBuilder<TaskDetailsBloc, TaskDetailsState>(
                  buildWhen: (previous, current) {
                if (current is TaskDetailsSectionUpdateState) {
                  return true;
                } else {
                  return false;
                }
              }, builder: (context, state) {
                return DropdownListWidget(
                  title: "Section",
                  items: taskDetailsBloc.screenConfig!.sections!
                      .map((e) => e.name!)
                      .toList(),
                  selectedItem: taskDetailsBloc.selectedSection?.name,
                  onChanged: (value) => taskDetailsBloc
                      .add(TaskDetailsOnSectionChangeEvent(value!)),
                );
              }),
            ),
          ],
        ),
        const SizedBox(height: 35),
        if (taskDetailsBloc.screenConfig?.task == null) ...[
          Center(
            child: BlocBuilder<TaskDetailsBloc, TaskDetailsState>(
                buildWhen: (previous, current) {
              if (current is TaskDetailsTaskNameUpdateState) {
                return true;
              } else {
                return false;
              }
            }, builder: (context, state) {
              return FilledButton.icon(
                onPressed: taskDetailsBloc.taskName.isNotEmpty
                    ? () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        taskDetailsBloc.add(TaskDetailsAddTaskEvent());
                      }
                    : null,
                label: const Text("Add Task"),
                icon: const Icon(Icons.add),
              );
            }),
          ),
          const SizedBox(height: 35),
        ] else
          const Divider(height: 0),
      ],
    );
  }
}
