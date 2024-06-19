class TaskHistoryState {}

class TaskHistoryScreenUpdatedState extends TaskHistoryState {}

class TaskHistoryScreenErrorState extends TaskHistoryState {
  final String message;
  TaskHistoryScreenErrorState(this.message);
}
