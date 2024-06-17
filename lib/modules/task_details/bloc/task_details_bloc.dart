import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:task_tracker/core/resources/data_state.dart';
import 'package:task_tracker/modules/kanban_board/models/section_model.dart';
import 'package:task_tracker/modules/kanban_board/models/task_model.dart';
import 'package:task_tracker/modules/task_details/bloc/task_details_event.dart';
import 'package:task_tracker/modules/task_details/bloc/task_details_state.dart';
import 'package:task_tracker/modules/task_details/config/task_details_screen_config.dart';
import 'package:task_tracker/modules/task_details/models/add_task_request_model.dart';
import 'package:task_tracker/modules/task_details/repository/task_details_repository.dart';

class TaskDetailsBloc extends Bloc<TaskDetailsEvent, TaskDetailsState> {
  TaskDetailsBloc({this.screenConfig}) : super(TaskDetailsState()) {
    on<TaskDetailsIntialEvent>(_taskDetailsIntialEvent);
    on<TaskDetailsOnTapDuedateEvent>(_taskDetailsOnTapDuedateEvent);
    on<TaskDetailsOnSectionChangeEvent>(_taskDetailsOnSectionChangeEvent);
    on<TaskDetailsTaskNameUpdateEvent>(_taskDetailsTaskNameUpdateEvent);
    on<TaskDetailsAddTaskEvent>(_taskDetailsAddTaskEvent);
    on<TaskDetailsEditTaskEvent>(_taskDetailsEditTaskEvent);
  }
  final TaskDetailsRepoInterfase _repository =
      GetIt.instance.get<TaskDetailsRepoInterfase>();
  TaskDetailsScreenConfig? screenConfig;
  bool isEditing = false;
  String taskName = "";
  String description = "";
  DateTime? dueDate;
  SectionModel? selectedSection;
  bool isDataUpdated = false;

  void _taskDetailsIntialEvent(
      TaskDetailsIntialEvent event, Emitter<TaskDetailsState> emit) async {
    if (screenConfig?.task == null) {
      isEditing = true;
    }
    selectedSection = screenConfig?.currentSection;
    emit(TaskDetailsSectionUpdateState());
  }

  void _taskDetailsOnTapDuedateEvent(TaskDetailsOnTapDuedateEvent event,
      Emitter<TaskDetailsState> emit) async {
    DateTime? dateRes = await showDatePicker(
      context: event.context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 1000),
      ),
      initialDate: dueDate,
    );

    if (dateRes != null) {
      dueDate = dateRes;
      emit(TaskDetailsDuedateUpdateState());
    }
  }

  void _taskDetailsOnSectionChangeEvent(TaskDetailsOnSectionChangeEvent event,
      Emitter<TaskDetailsState> emit) async {
    selectedSection = screenConfig!.sections!
        .firstWhere((e) => e.name == event.selectedSection);
    emit(TaskDetailsSectionUpdateState());
  }

  void _taskDetailsTaskNameUpdateEvent(TaskDetailsTaskNameUpdateEvent event,
      Emitter<TaskDetailsState> emit) async {
    taskName = event.taskName;
    emit(TaskDetailsTaskNameUpdateState());
  }

  SectionModel? sectionFromId(String id) {
    int i = screenConfig!.sections!.indexWhere((e) => e.id == id);
    if (i != -1) {
      return screenConfig!.sections![i];
    }
    return null;
  }

  void _taskDetailsAddTaskEvent(
      TaskDetailsAddTaskEvent event, Emitter<TaskDetailsState> emit) async {
    try {
      if (taskName.isEmpty) return;
      emit(TaskDetailsLoaderState(true));
      AddTaskRequestModel payload = AddTaskRequestModel(
        taskName: taskName,
        description: description,
        dueDate:
            dueDate != null ? DateFormat("y-MM-dd").format(dueDate!) : null,
        sectionId: selectedSection?.id,
      );

      DataState<TaskModel> dataState = await _repository.addTask(
          payload: payload, taskId: screenConfig?.task?.id);
      if (dataState is DataSuccess) {
        isDataUpdated = true;

        screenConfig = TaskDetailsScreenConfig(
          currentSection: selectedSection,
          task: dataState.data,
          sections: screenConfig?.sections,
        );

        isEditing = false;
        emit(TaskDetailsTaskAddedState());
      } else {
        emit(TaskDetailsTaskAddFailedState(
            dataState.error?.message ?? "Something went wrong"));
      }
    } catch (e, stack) {
      log(e.toString(), stackTrace: stack);
      emit(TaskDetailsTaskAddFailedState("Something went wrong"));
    } finally {
      emit(TaskDetailsLoaderState(false));
    }
  }

  void _taskDetailsEditTaskEvent(
      TaskDetailsEditTaskEvent event, Emitter<TaskDetailsState> emit) async {
    if (isEditing) {
      add(TaskDetailsAddTaskEvent());
    } else {
      isEditing = true;
      taskName = screenConfig?.task?.content ?? "";
      description = screenConfig?.task?.description ?? "";
      dueDate = screenConfig?.task?.due?.date != null
          ? DateTime.parse(screenConfig!.task!.due!.date!)
          : null;
      selectedSection = screenConfig?.task?.sectionId != null
          ? sectionFromId(screenConfig?.task?.sectionId ?? "")
          : null;
      emit(TaskDetailsScreenUpdateState());
    }
  }
}
