// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProjectModel {
  String? id;
  String? name;
  int? commentCount;
  String? color;
  bool? isShared;
  int? order;
  bool? isFavorite;
  bool? isInboxProject;
  bool? isTeamInbox;
  String? viewStyle;
  String? url;
  String? parentId;

  ProjectModel({
    this.id,
    this.name,
    this.commentCount,
    this.color,
    this.isShared,
    this.order,
    this.isFavorite,
    this.isInboxProject,
    this.isTeamInbox,
    this.viewStyle,
    this.url,
    this.parentId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'comment_count': commentCount,
      'color': color,
      'is_shared': isShared,
      'order': order,
      'is_favorite': isFavorite,
      'is_inbox_project': isInboxProject,
      'is_team_inbox': isTeamInbox,
      'view_style': viewStyle,
      'url': url,
      'parent_id': parentId,
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      commentCount:
          map['comment_count'] != null ? map['comment_count'] as int : null,
      color: map['color'] != null ? map['color'] as String : null,
      isShared: map['is_shared'] != null ? map['is_shared'] as bool : null,
      order: map['order'] != null ? map['order'] as int : null,
      isFavorite:
          map['is_favorite'] != null ? map['is_favorite'] as bool : null,
      isInboxProject: map['is_inbox_project'] != null
          ? map['is_inbox_project'] as bool
          : null,
      isTeamInbox:
          map['is_team_inbox'] != null ? map['is_team_inbox'] as bool : null,
      viewStyle: map['view_style'] != null ? map['view_style'] as String : null,
      url: map['url'] != null ? map['url'] as String : null,
      parentId: map['parent_id'] != null ? map['parent_id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectModel.fromJson(String source) =>
      ProjectModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
