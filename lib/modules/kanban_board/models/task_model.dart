import 'package:equatable/equatable.dart';

class TaskModel extends Equatable {
  final String? creatorId;
  final String? createdAt;
  final String? assigneeId;
  final String? assignerId;
  final int? commentCount;
  final bool? isCompleted;
  final String? content;
  final String? description;
  final Due? due;
  final dynamic duration;
  final String? id;
  final List<String>? labels;
  final int? order;
  final int? priority;
  final String? projectId;
  final String? sectionId;
  final String? parentId;
  final String? url;

  const TaskModel(
      {this.creatorId,
      this.createdAt,
      this.assigneeId,
      this.assignerId,
      this.commentCount,
      this.isCompleted,
      this.content,
      this.description,
      this.due,
      this.duration,
      this.id,
      this.labels,
      this.order,
      this.priority,
      this.projectId,
      this.sectionId,
      this.parentId,
      this.url});

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      creatorId: json["creator_id"],
      createdAt: json["created_at"],
      assigneeId: json["assignee_id"],
      assignerId: json["assigner_id"],
      commentCount: json["comment_count"],
      isCompleted: json["is_completed"],
      content: json["content"],
      description: json["description"],
      due: json["due"] == null ? null : Due.fromJson(json["due"]),
      duration: json["duration"],
      id: json["id"],
      labels: json["labels"] == null ? null : List<String>.from(json["labels"]),
      order: json["order"],
      priority: json["priority"],
      projectId: json["project_id"],
      sectionId: json["section_id"],
      parentId: json["parent_id"],
      url: json["url"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["creator_id"] = creatorId;
    data["created_at"] = createdAt;
    data["assignee_id"] = assigneeId;
    data["assigner_id"] = assignerId;
    data["comment_count"] = commentCount;
    data["is_completed"] = isCompleted;
    data["content"] = content;
    data["description"] = description;
    if (due != null) {
      data["due"] = due?.toJson();
    }
    data["duration"] = duration;
    data["id"] = id;
    if (labels != null) {
      data["labels"] = labels;
    }
    data["order"] = order;
    data["priority"] = priority;
    data["project_id"] = projectId;
    data["section_id"] = sectionId;
    data["parent_id"] = parentId;
    data["url"] = url;
    return data;
  }

  @override
  List<Object?> get props => [
        creatorId,
        createdAt,
        assigneeId,
        assignerId,
        isCompleted,
        content,
        description,
        due,
        duration,
        id,
        labels,
        order,
        priority,
        projectId,
        sectionId,
        parentId,
        url
      ];
}

class Due extends Equatable {
  final String? date;
  final bool? isRecurring;
  final String? datetime;
  final String? string;
  final String? timezone;

  const Due(
      {this.date, this.isRecurring, this.datetime, this.string, this.timezone});

  factory Due.fromJson(Map<String, dynamic> json) {
    return Due(
      date: json["date"],
      isRecurring: json["is_recurring"],
      datetime: json["datetime"],
      string: json["string"],
      timezone: json["timezone"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["date"] = date;
    data["is_recurring"] = isRecurring;
    data["datetime"] = datetime;
    data["string"] = string;
    data["timezone"] = timezone;
    return data;
  }

  @override
  List<Object?> get props => [
        date,
        isRecurring,
        datetime,
        string,
        timezone,
      ];
}
