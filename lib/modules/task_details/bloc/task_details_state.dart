class TaskDetailsState {}

class TaskDetailsScreenUpdateState extends TaskDetailsState {}

class TaskDetailsDuedateUpdateState extends TaskDetailsState {}

class TaskDetailsSectionUpdateState extends TaskDetailsState {}

class TaskDetailsTaskNameUpdateState extends TaskDetailsState {}

class TaskDetailsTaskAddedState extends TaskDetailsState {}

class TaskDetailsLoaderState extends TaskDetailsState {
  final bool showLoader;
  TaskDetailsLoaderState(this.showLoader);
}

class TaskDetailsTaskAddFailedState extends TaskDetailsState {
  final String message;
  TaskDetailsTaskAddFailedState(this.message);
}

class TaskDetailsTaskClosedState extends TaskDetailsState {
  final String message;
  final bool isClosed;
  TaskDetailsTaskClosedState({required this.isClosed, required this.message});
}

class TaskDetailsTaskTimeLoadedState extends TaskDetailsState {}

class TaskDetailsErrorState extends TaskDetailsState {
  final String message;
  TaskDetailsErrorState(this.message);
}

class TaskDetailsSpendTimeUpdatedState extends TaskDetailsState {}
