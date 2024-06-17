class AddTaskRequestModel {
  final String taskName;
  final String? description;
  final String? sectionId;
  final String? dueDate;
  AddTaskRequestModel({
    required this.taskName,
    this.description,
    this.sectionId,
    this.dueDate,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'content': taskName,
      'description': description,
      'section_id': sectionId,
      'due_date': dueDate,
    };
  }
}
