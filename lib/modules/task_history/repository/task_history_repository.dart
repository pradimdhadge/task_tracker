import 'dart:developer';

import 'package:task_tracker/core/network/api_client_interface.dart';
import 'package:task_tracker/core/resources/repo_helper.dart';
import 'package:task_tracker/modules/kanban_board/models/task_model.dart';

import '../../../core/constants/constants.dart';
import '../../../core/resources/data_state.dart';
import '../../../core/resources/local_storage.dart';

abstract class TaskHistoryRepoInterface {
  Future<DataState<List<TaskModel>>> getTaskHistory();
}

class TaskHistoryRepository
    with RepoHelper
    implements TaskHistoryRepoInterface {
  @override
  Future<DataState<List<TaskModel>>> getTaskHistory() async {
    try {
      LocalStorage storage = LocalStorage();
      Map<String, dynamic> response =
          await storage.getAllValue(boxName: AppConstants.dbDocuments.taskBox);

      return DataSuccess(
          response.values.map((e) => TaskModel.fromJson(e)).toList());
    } catch (e, stack) {
      log(e.toString(), stackTrace: stack);
      return DataFailed(ApiError(errorResponse: ErrorResponse()));
    }
  }
}
