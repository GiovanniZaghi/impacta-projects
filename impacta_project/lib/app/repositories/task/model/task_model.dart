class TaskModel {
  final int id;
  final String title;
  final String description;
  final String status;
  Board? board;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.board,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      status: json['status'],
      board: json['board'] != null ? Board.fromJson(json['board']) : null,
    );
  }

  @override
  String toString() {
    return 'TaskModel{id: $id, title: $title, description: $description, status: $status}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'board': board?.toJson(), // ✅ corrigido
    };
  }
}

class Board {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Board({this.id, this.name, this.createdAt, this.updatedAt});

  Board.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
