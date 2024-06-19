import 'package:flutter/material.dart';

class TaskDetailsEvent {}

class TaskDetailsIntialEvent extends TaskDetailsEvent {}

class TaskDetailsOnTapDuedateEvent extends TaskDetailsEvent {
  final BuildContext context;
  TaskDetailsOnTapDuedateEvent(this.context);
}

class TaskDetailsOnSectionChangeEvent extends TaskDetailsEvent {
  final String selectedSection;
  TaskDetailsOnSectionChangeEvent(this.selectedSection);
}

class TaskDetailsTaskNameUpdateEvent extends TaskDetailsEvent {
  final String taskName;
  TaskDetailsTaskNameUpdateEvent(this.taskName);
}

class TaskDetailsAddTaskEvent extends TaskDetailsEvent {}

class TaskDetailsEditTaskEvent extends TaskDetailsEvent {}

class TaskDetailsDeleteTaskEvent extends TaskDetailsEvent {}

class TaskDetailsCloseTaskEvent extends TaskDetailsEvent {}

class TaskDetailsStartTaskEvent extends TaskDetailsEvent {}

class TaskDetailsPauseTaskEvent extends TaskDetailsEvent {}

class TaskDetailsTimerUpdateEvent extends TaskDetailsEvent {}
