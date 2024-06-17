import 'package:flutter/material.dart';
import 'package:task_tracker/object_initializer/object_initializer.dart';
import 'config/routes/go_router.dart';

void main() async {
  await ObjectInitializer.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme =
        ColorScheme.fromSeed(seedColor: Colors.deepPurple);
    return MaterialApp.router(
      title: 'Task Tracker',
      routerConfig: router,
      theme: ThemeData(
        colorScheme: scheme,
        useMaterial3: true,
        scaffoldBackgroundColor: scheme.surfaceContainerLowest,
        appBarTheme: AppBarTheme.of(context).copyWith(
          backgroundColor: scheme.surfaceContainerLowest,
          surfaceTintColor: scheme.surfaceContainerLowest,
        ),
      ),
    );
  }
}
