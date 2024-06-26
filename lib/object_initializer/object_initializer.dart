import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:task_tracker/core/network/api_client_impl.dart';
import 'package:task_tracker/core/network/api_client_interface.dart';
import 'package:task_tracker/core/resources/local_storage.dart';
import 'package:task_tracker/modules/kanban_board/repository/kanban_board_repo.dart';
import 'package:task_tracker/modules/task_details/repository/task_details_repository.dart';
import 'package:task_tracker/modules/task_history/repository/task_history_repository.dart';

class ObjectInitializer {
  static final ObjectInitializer instance = ObjectInitializer();
  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await LocalStorage.init();
    final ApiClientInterface client =
        GetIt.instance.registerSingleton<ApiClientInterface>(ApiClient());
    await client.init();

    GetIt.instance.registerLazySingleton<KanbanBoardRepoInterface>(
        () => KanbanBoardRepo());

    GetIt.instance.registerLazySingleton<TaskDetailsRepoInterfase>(
        () => TaskDetailsRepository());

    GetIt.instance.registerLazySingleton<TaskHistoryRepoInterface>(
        () => TaskHistoryRepository());
  }
}
