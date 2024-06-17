import 'dart:convert';

class SectionModel {
  String? id;
  String? projectId;
  int? order;
  String? name;

  SectionModel({this.id, this.projectId, this.order, this.name});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'project_id': projectId,
      'order': order,
      'name': name,
    };
  }

  factory SectionModel.fromMap(Map<String, dynamic> map) {
    return SectionModel(
      id: map['id'] != null ? map['id'] as String : null,
      projectId: map['project_id'] != null ? map['project_id'] as String : null,
      order: map['order'] != null ? map['order'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SectionModel.fromJson(String source) =>
      SectionModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
