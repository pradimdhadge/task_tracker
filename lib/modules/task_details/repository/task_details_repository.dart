import 'package:task_tracker/core/constants/constants.dart';
import 'package:task_tracker/core/resources/local_storage.dart';
import 'package:task_tracker/core/resources/repo_helper.dart';
import 'package:task_tracker/modules/task_details/models/task_time_model.dart';

import '../../../core/network/api_client_interface.dart';
import '../../../core/resources/data_state.dart';
import '../../kanban_board/models/task_model.dart';
import '../models/add_task_request_model.dart';

abstract class TaskDetailsRepoInterfase {
  Future<DataState<TaskModel>> addTask(
      {required AddTaskRequestModel payload, String? taskId});
  Future<DataState<bool>> deleteTask({required String taskId});
  Future<DataState<bool>> closeTask({required String taskId});
  Future<DataState<bool>> saveTaskInLocal(
      {required TaskModel task, required num spendTime});
  Future<DataState<bool>> startTask({required String taskId});
  Future<DataState<bool>> pauseTask(
      {required String taskId, required int spendTime});
  Future<DataState<TaskTimeModel>> getTaskTime({required String taskId});
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
  Future<DataState<bool>> closeTask({required String taskId}) async {
    final ClientResponse response = await client.request(
      RequestParam(
        path: "${paths.tasks}/$taskId/close",
        methodType: MethodType.post,
      ),
    );

    if (response.apiResponse != null) {
      return const DataSuccess(true);
    } else {
      return DataFailed(response.apiError!);
    }
  }

  @override
  Future<DataState<bool>> deleteTask({required String taskId}) async {
    final ClientResponse response = await client.request(
      RequestParam(
          path: "${paths.tasks}/$taskId", methodType: MethodType.delete),
    );

    if (response.apiResponse != null) {
      await removeTaskTime(taskId);
      return const DataSuccess(true);
    } else {
      return DataFailed(response.apiError!);
    }
  }

  @override
  Future<DataState<bool>> saveTaskInLocal(
      {required TaskModel task, required num spendTime}) async {
    try {
      LocalStorage storage = LocalStorage();
      await storage.putValue(
        boxName: AppConstants.dbDocuments.taskBox,
        key: task.id!,
        value: task.toJson(),
      );
      await pauseTask(taskId: task.id!, spendTime: spendTime);
      return const DataSuccess(true);
    } catch (e) {
      return DataFailed(ApiError(errorResponse: ErrorResponse()));
    }
  }

  @override
  Future<DataState<bool>> pauseTask(
      {required String taskId, required num spendTime}) async {
    try {
      LocalStorage storage = LocalStorage();
      final data = await storage.getValue(
          boxName: AppConstants.dbDocuments.taskTimerBox, key: taskId);
      TaskTimeModel currentTime;
      if (data is Map) {
        currentTime = TaskTimeModel.fromMap(data);
      } else {
        currentTime = TaskTimeModel(taskId: taskId);
      }
      currentTime.spendTime = spendTime;
      currentTime.startedFrom = null;

      await storage.putValue(
        boxName: AppConstants.dbDocuments.taskTimerBox,
        key: taskId,
        value: currentTime.toMap(),
      );
      return const DataSuccess(true);
    } catch (e) {
      return DataFailed(ApiError(errorResponse: ErrorResponse()));
    }
  }

  @override
  Future<DataState<TaskTimeModel>> getTaskTime({required String taskId}) async {
    LocalStorage storage = LocalStorage();
    final data = await storage.getValue(
        boxName: AppConstants.dbDocuments.taskTimerBox, key: taskId);
    if (data is Map) {
      return DataSuccess(TaskTimeModel.fromMap(data));
    } else {
      return DataSuccess(TaskTimeModel(taskId: taskId));
    }
  }

  Future<void> removeTaskTime(String taskId) async {
    LocalStorage storage = LocalStorage();
    storage.deleteValue(
        boxName: AppConstants.dbDocuments.taskTimerBox, key: taskId);
  }

  @override
  Future<DataState<bool>> startTask({required String taskId}) async {
    try {
      LocalStorage storage = LocalStorage();
      final data = await storage.getValue(
          boxName: AppConstants.dbDocuments.taskTimerBox, key: taskId);
      TaskTimeModel currentTime;
      if (data is Map) {
        currentTime = TaskTimeModel.fromMap(data);
      } else {
        currentTime = TaskTimeModel(taskId: taskId);
      }
      currentTime.startedFrom = DateTime.now().millisecondsSinceEpoch;
      await storage.putValue(
        boxName: AppConstants.dbDocuments.taskTimerBox,
        key: taskId,
        value: currentTime.toMap(),
      );
      return const DataSuccess(true);
    } catch (e) {
      return DataFailed(ApiError(errorResponse: ErrorResponse()));
    }
  }
}
