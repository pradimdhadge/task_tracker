class KanbanBoardState {}

class KanbanBoardLoadingState extends KanbanBoardState {}

class KanbanBoardSectionUpdatedState extends KanbanBoardState {}

class KanbanBoardTaskUpdatedState extends KanbanBoardState {}

class KanbanBoardLoaderState extends KanbanBoardState {
  final bool showLoader;
  KanbanBoardLoaderState(this.showLoader);
}

class KanbanBoardErrorState extends KanbanBoardState {
  final String message;
  KanbanBoardErrorState({required this.message});
}
