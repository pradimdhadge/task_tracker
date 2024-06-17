import 'package:task_tracker/core/resources/repo_helper.dart';
import 'package:task_tracker/modules/kanban_board/models/project_model.dart';
import 'package:task_tracker/modules/kanban_board/models/section_model.dart';
import 'package:task_tracker/modules/kanban_board/models/task_model.dart';

import '../../../core/network/api_client_interface.dart';
import '../../../core/resources/data_state.dart';

abstract class KanbanBoardRepoInterface {
  Future<DataState<ProjectModel>> getProject();
  Future<DataState<List<SectionModel>>> getSections(
      {required String projectId});
  Future<DataState<SectionModel>> createSection(
      {required String name, required String projectId, int? order});
  Future<DataState<SectionModel>> updateSection();
  Future<DataState<bool>> deleteSection();
  Future<DataState<List<TaskModel>>> getTasks();
}

class KanbanBoardRepo with RepoHelper implements KanbanBoardRepoInterface {
  @override
  Future<DataState<SectionModel>> createSection(
      {required String name, required String projectId, int? order}) async {
    final ClientResponse response = await client.request(
      RequestParam(
        path: paths.sections,
        methodType: MethodType.post,
        payload: {"name": name, "project_id": projectId, "order": order},
      ),
    );

    if (response.apiResponse != null) {
      return DataSuccess(SectionModel.fromMap(response.apiResponse?.data));
    } else {
      return DataFailed(response.apiError!);
    }
  }

  @override
  Future<DataState<bool>> deleteSection() {
    // TODO: implement deleteSection
    throw UnimplementedError();
  }

  @override
  Future<DataState<ProjectModel>> getProject() async {
    final ClientResponse response = await client.request(
      RequestParam(
        path: "${paths.projects}/2334795901",
        methodType: MethodType.get,
      ),
    );

    if (response.apiResponse != null) {
      return DataSuccess(ProjectModel.fromMap(response.apiResponse?.data));
    } else {
      return DataFailed(response.apiError!);
    }
  }

  @override
  Future<DataState<List<SectionModel>>> getSections(
      {required String projectId}) async {
    final ClientResponse response = await client.request(RequestParam(
      path: paths.sections,
      methodType: MethodType.get,
      payload: {"project_id": projectId},
    ));

    if (response.apiResponse != null) {
      return DataSuccess((response.apiResponse?.data as List)
          .map((e) => SectionModel.fromMap(e))
          .toList());
    } else {
      return DataFailed(response.apiError!);
    }
  }

  @override
  Future<DataState<List<TaskModel>>> getTasks() async {
    final ClientResponse response = await client.request(RequestParam(
      path: paths.tasks,
      methodType: MethodType.get,
    ));

    if (response.apiResponse != null) {
      return DataSuccess((response.apiResponse?.data as List)
          .map((e) => TaskModel.fromJson(e))
          .toList());
    } else {
      return DataFailed(response.apiError!);
    }
  }

  @override
  Future<DataState<SectionModel>> updateSection() {
    // TODO: implement updateSection
    throw UnimplementedError();
  }
}
