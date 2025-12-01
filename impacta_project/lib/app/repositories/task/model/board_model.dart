import 'package:impacta_project/app/repositories/profile/model/user_model.dart';
import 'package:impacta_project/app/repositories/task/model/task_model.dart';

class BoardModel {
  final int? id;
  final String? name;
  final List<TaskModel>? tasks;
  final List<Users>? users;
  final String? createdAt;
  final String? updatedAt;

  BoardModel({
    this.id,
    this.name,
    this.tasks,
    this.users,
    this.createdAt,
    this.updatedAt,
  });

  factory BoardModel.fromJson(Map<String, dynamic> json) {
    return BoardModel(
      id: json['id'],
      name: json['name'],
      tasks:
          json['tasks'] != null
              ? List<TaskModel>.from(
                json['tasks'].map((v) => TaskModel.fromJson(v)),
              )
              : null,
      users:
          json['users'] != null
              ? List<Users>.from(json['users'].map((v) => Users.fromJson(v)))
              : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tasks': tasks?.map((v) => v.toJson()).toList(),
      'users': users?.map((v) => v.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
