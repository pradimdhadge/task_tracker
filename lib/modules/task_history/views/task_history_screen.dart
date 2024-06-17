import 'package:flutter/material.dart';
import 'package:task_tracker/modules/kanban_board/views/task_card.dart';

class TaskHistoryScreen extends StatelessWidget {
  const TaskHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Completed Task"),
      ),
      // body: ListView.builder(
      //   padding: const EdgeInsets.symmetric(vertical: 20),
      //   itemBuilder: (context, index) {
      //     return const TaskCard();
      //   },
      // ),
    );
  }
}
