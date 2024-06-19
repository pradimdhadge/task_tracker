class CommentModel {
  String? content;
  String? id;
  String? postedAt;
  dynamic projectId;
  String? taskId;
  Attachment? attachment;

  CommentModel(
      {this.content,
      this.id,
      this.postedAt,
      this.projectId,
      this.taskId,
      this.attachment});

  CommentModel.fromJson(Map<String, dynamic> json) {
    content = json["content"];
    id = json["id"];
    postedAt = json["posted_at"];
    projectId = json["project_id"];
    taskId = json["task_id"];
    attachment = json["attachment"] == null
        ? null
        : Attachment.fromJson(json["attachment"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["content"] = content;
    data["id"] = id;
    data["posted_at"] = postedAt;
    data["project_id"] = projectId;
    data["task_id"] = taskId;
    if (attachment != null) {
      data["attachment"] = attachment?.toJson();
    }
    return data;
  }
}

class Attachment {
  String? fileName;
  String? fileType;
  String? fileUrl;
  String? resourceType;

  Attachment({this.fileName, this.fileType, this.fileUrl, this.resourceType});

  Attachment.fromJson(Map<String, dynamic> json) {
    fileName = json["file_name"];
    fileType = json["file_type"];
    fileUrl = json["file_url"];
    resourceType = json["resource_type"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["file_name"] = fileName;
    data["file_type"] = fileType;
    data["file_url"] = fileUrl;
    data["resource_type"] = resourceType;
    return data;
  }
}
