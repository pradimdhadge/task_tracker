class KanbanBoardState {}

class KanbanBoardLoadingState extends KanbanBoardState {}

class KanbanBoardSectionUpdated extends KanbanBoardState {}

class KanbanBoardTaskUpdatedState extends KanbanBoardState {}

class KanbanBoardErrorState extends KanbanBoardState {
  final String message;
  KanbanBoardErrorState({required this.message});
}
