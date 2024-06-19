import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:task_tracker/core/resources/data_state.dart';
import 'package:task_tracker/modules/kanban_board/models/task_model.dart';
import 'package:task_tracker/modules/task_history/bloc/task_history_event.dart';
import 'package:task_tracker/modules/task_history/bloc/task_history_state.dart';
import 'package:task_tracker/modules/task_history/repository/task_history_repository.dart';

class TaskHistoryBloc extends Bloc<TaskHistoryEvent, TaskHistoryState> {
  TaskHistoryBloc() : super(TaskHistoryState()) {
    on<TaskHistoryIntialEvent>(_taskHistoryIntialEvent);
  }

  final TaskHistoryRepoInterface _repository =
      GetIt.instance.get<TaskHistoryRepoInterface>();
  List<TaskModel> taskList = [];
  bool isTaskLoading = true;

  void _taskHistoryIntialEvent(
      TaskHistoryIntialEvent event, Emitter<TaskHistoryState> emit) async {
    try {
      DataState<List<TaskModel>> dataState = await _repository.getTaskHistory();
      isTaskLoading = false;
      if (dataState is DataSuccess) {
        taskList = dataState.data ?? [];
      } else {
        emit(TaskHistoryScreenErrorState("Something went wrong"));
      }
    } catch (e) {
      emit(TaskHistoryScreenErrorState("Something went wrong"));
    } finally {
      emit(TaskHistoryScreenUpdatedState());
    }
  }
}
