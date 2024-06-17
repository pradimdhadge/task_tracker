import 'package:task_tracker/core/resources/repo_helper.dart';

import '../../../core/network/api_client_interface.dart';
import '../../../core/resources/data_state.dart';
import '../../kanban_board/models/task_model.dart';
import '../models/add_task_request_model.dart';

abstract class TaskDetailsRepoInterfase {
  Future<DataState<TaskModel>> addTask(
      {required AddTaskRequestModel payload, String? taskId});
  Future<DataState<bool>> deleteTask();
  Future<DataState<bool>> closeTask();
}

class TaskDetailsRepository
    with RepoHelper
    implements TaskDetailsRepoInterfase {
  @override
  Future<DataState<TaskModel>> addTask(
      {required AddTaskRequestModel payload, String? taskId}) async {
    final ClientResponse response = await client.request(
      RequestParam(
        path: "${paths.tasks}${taskId != null ? "/$taskId" : ""}",
        methodType: MethodType.post,
        payload: payload.toMap(),
      ),
    );

    if (response.apiResponse != null) {
      return DataSuccess(TaskModel.fromJson(response.apiResponse?.data));
    } else {
      return DataFailed(response.apiError!);
    }
  }

  @override
  Future<DataState<bool>> closeTask() {
    // TODO: implement closeTask
    throw UnimplementedError();
  }

  @override
  Future<DataState<bool>> deleteTask() {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }
}
