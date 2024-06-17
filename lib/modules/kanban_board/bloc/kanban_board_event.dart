abstract class KanbanBoardEvent {}

class KanbanBoardInitialEvent extends KanbanBoardEvent {}

class KanbanBoardCreateSectionEvent extends KanbanBoardEvent {}

class KanbanBoardUpdateSectionEvent extends KanbanBoardEvent {}

class KanbanBoardDeleteSectionEvent extends KanbanBoardEvent {}

class KanbanBoardCreateTaskEvent extends KanbanBoardEvent {}

class KanbanBoardUpdateTaskEvent extends KanbanBoardEvent {}

class KanbanBoardDeleteTaskEvent extends KanbanBoardEvent {}

class KanbanBoardCloseTaskEvent extends KanbanBoardEvent {}
