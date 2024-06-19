import 'dart:convert';

class TaskTimeModel {
  final String? taskId;
  num spendTime;
  num? startedFrom;
  TaskTimeModel({
    required this.taskId,
    this.spendTime = 0,
    this.startedFrom,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'taskId': taskId,
      'spendTime': spendTime,
      'startedFrom': startedFrom,
    };
  }

  factory TaskTimeModel.fromMap(Map<dynamic, dynamic> map) {
    return TaskTimeModel(
      taskId: map['taskId'] as String,
      spendTime: map['spendTime'] ?? 0,
      startedFrom: map['startedFrom'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskTimeModel.fromJson(String source) =>
      TaskTimeModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
