import 'package:task_tracker/modules/kanban_board/models/task_model.dart';

abstract class KanbanBoardEvent {}

class KanbanBoardInitialEvent extends KanbanBoardEvent {}

class KanbanBoardCreateSectionEvent extends KanbanBoardEvent {
  final String sectionName;
  KanbanBoardCreateSectionEvent({
    required this.sectionName,
  });
}

class KanbanBoardUpdateSectionEvent extends KanbanBoardEvent {
  final String sectionId;
  final String sectionName;
  KanbanBoardUpdateSectionEvent({
    required this.sectionId,
    required this.sectionName,
  });
}

class KanbanBoardDeleteSectionEvent extends KanbanBoardEvent {
  final String sectionId;
  KanbanBoardDeleteSectionEvent(this.sectionId);
}

class KanbanBoardCreateTaskEvent extends KanbanBoardEvent {
  final TaskModel newTask;
  KanbanBoardCreateTaskEvent(this.newTask);
}

class KanbanBoardUpdateTaskEvent extends KanbanBoardEvent {
  dynamic updatedData;
  TaskModel currentTask;
  KanbanBoardUpdateTaskEvent({this.updatedData, required this.currentTask});
}

class KanbanBoardDeleteTaskEvent extends KanbanBoardEvent {}

class KanbanBoardCloseTaskEvent extends KanbanBoardEvent {}

class KanbanBoardOnPageChangeEvent extends KanbanBoardEvent {
  final int pageIndex;
  KanbanBoardOnPageChangeEvent(this.pageIndex);
}
