import 'dart:async';
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
import 'package:task_tracker/modules/task_details/models/task_time_model.dart';
import 'package:task_tracker/modules/task_details/repository/task_details_repository.dart';

class TaskDetailsBloc extends Bloc<TaskDetailsEvent, TaskDetailsState> {
  TaskDetailsBloc({this.screenConfig}) : super(TaskDetailsState()) {
    on<TaskDetailsIntialEvent>(_taskDetailsIntialEvent);
    on<TaskDetailsOnTapDuedateEvent>(_taskDetailsOnTapDuedateEvent);
    on<TaskDetailsOnSectionChangeEvent>(_taskDetailsOnSectionChangeEvent);
    on<TaskDetailsTaskNameUpdateEvent>(_taskDetailsTaskNameUpdateEvent);
    on<TaskDetailsAddTaskEvent>(_taskDetailsAddTaskEvent);
    on<TaskDetailsEditTaskEvent>(_taskDetailsEditTaskEvent);
    on<TaskDetailsDeleteTaskEvent>(_taskDetailsDeleteTaskEvent);
    on<TaskDetailsCloseTaskEvent>(_taskDetailsCloseTaskEvent);
    on<TaskDetailsStartTaskEvent>(_taskDetailsStartTaskEvent);
    on<TaskDetailsPauseTaskEvent>(_taskDetailsPauseTaskEvent);
    on<TaskDetailsTimerUpdateEvent>(_taskDetailsTimerUpdateEvent);
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
  bool isTaskTimeLoading = true;
  TaskTimeModel? taskTime;
  Duration spendTime = const Duration();
  Timer? _timer;
  bool get isTaskCompleted => screenConfig?.task?.isCompleted ?? true;

  void _taskDetailsIntialEvent(
      TaskDetailsIntialEvent event, Emitter<TaskDetailsState> emit) async {
    if (screenConfig?.task == null) {
      isEditing = true;
    }
    selectedSection = screenConfig?.currentSection;
    emit(TaskDetailsSectionUpdateState());

    if (screenConfig?.task != null) {
      DataState<TaskTimeModel> dataState =
          await _repository.getTaskTime(taskId: screenConfig!.task!.id!);
      if (dataState is DataSuccess) {
        taskTime = dataState.data;
        if (taskTime?.startedFrom != null) {
          Duration diff = DateTime.now().difference(
              DateTime.fromMillisecondsSinceEpoch(
                  taskTime!.startedFrom!.toInt()));
          taskTime!.spendTime = taskTime!.spendTime + diff.inSeconds;
          spendTime = Duration(seconds: taskTime!.spendTime.toInt());
          _startTimer();
        }
      }
      spendTime = Duration(seconds: taskTime!.spendTime.toInt());
      isTaskTimeLoading = false;
      emit(TaskDetailsTaskTimeLoadedState());
    }
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
    if (screenConfig?.sections == null) return null;

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
            dataState.error?.errorResponse?.error ?? "Something went wrong"));
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

  void _taskDetailsStartTaskEvent(
      TaskDetailsStartTaskEvent event, Emitter<TaskDetailsState> emit) async {
    try {
      DataState<bool> dataState =
          await _repository.startTask(taskId: screenConfig!.task!.id!);

      if (dataState is DataSuccess) {
        spendTime = Duration(seconds: taskTime!.spendTime.toInt());
        taskTime?.startedFrom = DateTime.now().millisecondsSinceEpoch;
        emit(TaskDetailsTaskTimeLoadedState());
        _startTimer();
      } else {
        emit(TaskDetailsErrorState("Something went wrong"));
      }
    } catch (e) {
      emit(TaskDetailsErrorState("Something went wrong"));
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = null;
    _timer = Timer.periodic(const Duration(seconds: 1), (time) {
      if (!isClosed) {
        spendTime = Duration(seconds: spendTime.inSeconds + 1);
        taskTime!.spendTime = spendTime.inSeconds;
        add(TaskDetailsTimerUpdateEvent());
      } else {
        _timer?.cancel();
        _timer == null;
      }
    });
  }

  void _taskDetailsTimerUpdateEvent(
      TaskDetailsTimerUpdateEvent event, Emitter<TaskDetailsState> emit) async {
    emit(TaskDetailsSpendTimeUpdatedState());
  }

  void _taskDetailsPauseTaskEvent(
      TaskDetailsPauseTaskEvent event, Emitter<TaskDetailsState> emit) async {
    try {
      DataState<bool> dataState = await _repository.pauseTask(
          taskId: screenConfig!.task!.id!, spendTime: spendTime.inSeconds);

      if (dataState is DataSuccess) {
        _timer?.cancel();
        _timer = null;
        taskTime?.startedFrom = null;
        emit(TaskDetailsTaskTimeLoadedState());
      } else {
        emit(TaskDetailsErrorState("Something went wrong"));
      }
    } catch (e) {
      emit(TaskDetailsErrorState("Something went wrong"));
    }
  }

  void _taskDetailsDeleteTaskEvent(
      TaskDetailsDeleteTaskEvent event, Emitter<TaskDetailsState> emit) async {
    try {
      emit(TaskDetailsLoaderState(true));
      DataState<bool> dataState =
          await _repository.deleteTask(taskId: screenConfig?.task?.id ?? "");
      emit(TaskDetailsLoaderState(false));
      if (dataState is DataSuccess) {
        emit(TaskDetailsTaskClosedState(
            isClosed: true, message: "Task has been deleted successfully"));
        screenConfig = null;
      } else {
        emit(TaskDetailsTaskClosedState(
            isClosed: false,
            message: dataState.error?.errorResponse?.error ??
                "Somthing went wrong"));
      }
    } catch (e) {
      emit(TaskDetailsTaskClosedState(
          isClosed: false, message: "Somthing went wrong"));
    }
  }

  void _taskDetailsCloseTaskEvent(
      TaskDetailsCloseTaskEvent event, Emitter<TaskDetailsState> emit) async {
    try {
      emit(TaskDetailsLoaderState(true));
      DataState<bool> dataState =
          await _repository.closeTask(taskId: screenConfig!.task!.id!);
      emit(TaskDetailsLoaderState(false));

      if (dataState is DataSuccess) {
        screenConfig!.task!.isCompleted = true;

        await _repository.saveTaskInLocal(
            task: screenConfig!.task!, spendTime: spendTime.inSeconds);
        emit(TaskDetailsTaskClosedState(
            isClosed: true, message: "Task has been closed successfully"));
        screenConfig = null;
      } else {
        emit(TaskDetailsTaskClosedState(
            isClosed: false,
            message: dataState.error?.errorResponse?.error ??
                "Somthing went wrong"));
      }
    } catch (e) {
      emit(TaskDetailsTaskClosedState(
          isClosed: false, message: "Somthing went wrong"));
    }
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
