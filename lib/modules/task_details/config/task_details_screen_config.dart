import 'package:task_tracker/modules/kanban_board/models/section_model.dart';
import 'package:task_tracker/modules/kanban_board/models/task_model.dart';

class TaskDetailsScreenConfig {
  TaskModel? task;
  List<SectionModel>? sections;
  SectionModel? currentSection;
  TaskDetailsScreenConfig({
    this.task,
    this.sections,
    this.currentSection,
  });
}
