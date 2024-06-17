import 'package:go_router/go_router.dart';
import 'package:task_tracker/config/routes/app_routes.dart';
import 'package:task_tracker/modules/kanban_board/views/kanban_board_screen.dart';
import 'package:task_tracker/modules/task_details/config/task_details_screen_config.dart';
import 'package:task_tracker/modules/task_details/views/task_details.dart';

import '../../modules/task_history/views/task_history_screen.dart';

final router = GoRouter(
  initialLocation: AppRoutes.kabanBoard,
  routes: [
    GoRoute(
      path: AppRoutes.kabanBoard,
      builder: (context, state) => const KanbanBoard(),
    ),
    GoRoute(
      path: AppRoutes.taskDetails,
      builder: (context, state) => TaskDetailsScreen(
        config: state.extra as TaskDetailsScreenConfig?,
      ),
    ),
    GoRoute(
      path: AppRoutes.taskHistory,
      builder: (context, state) => const TaskHistoryScreen(),
    ),
  ],
);
