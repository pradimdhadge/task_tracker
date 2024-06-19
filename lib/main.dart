import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/modules/themes/bloc/theme_bloc.dart';
import 'package:task_tracker/modules/themes/bloc/theme_event.dart';
import 'package:task_tracker/modules/themes/bloc/theme_state.dart';
import 'package:task_tracker/object_initializer/object_initializer.dart';
import 'config/routes/go_router.dart';

void main() async {
  await ObjectInitializer.instance.init();
  runApp(const TaskTrackerApp());
}

class TaskTrackerApp extends StatelessWidget {
  const TaskTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc()..add(ThemeInitialEvent()),
      child: const TaskTrackerAppView(),
    );
  }
}

class TaskTrackerAppView extends StatelessWidget {
  const TaskTrackerAppView({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeBloc themeBloc = context.read<ThemeBloc>();

    return BlocBuilder<ThemeBloc, ThemeState>(
      bloc: themeBloc,
      buildWhen: (previous, current) {
        if (current is ThemeChangedState) {
          return true;
        } else {
          return false;
        }
      },
      builder: (context, state) {
        return MaterialApp.router(
          title: 'Task Tracker',
          routerConfig: router,
          theme: ThemeData(
            colorScheme: themeBloc.scheme,
            useMaterial3: true,
            scaffoldBackgroundColor: themeBloc.scheme.surfaceContainerLowest,
            appBarTheme: AppBarTheme.of(context).copyWith(
              backgroundColor: themeBloc.scheme.surfaceContainerLowest,
              surfaceTintColor: themeBloc.scheme.surfaceContainerLowest,
            ),
          ),
        );
      },
    );
  }
}
