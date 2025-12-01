import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:impacta_project/app/repositories/task/i_task_repository.dart';
import 'package:impacta_project/app/repositories/task/model/board_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/task_model.dart';

class TaskRepository implements ITaskRepository {
  late SharedPreferences prefs;
  TaskRepository();

  @override
  Future<void> createTask({
    required String title,
    required String description,
    required int boardId,
  }) async {
    try {
      prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('id');

      var url = 'http://10.0.2.2:3000/tasks/$userId/$boardId';

      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"title": title, "description": description}),
      );

      final data = json.decode(response.body);
      print(" oq tem aq ${data}");
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<void> createBoard({required String title}) async {
    try {
      prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('id');

      var url = 'http://10.0.2.2:3000/boards';

      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": title, "userId": userId}),
      );

      final data = json.decode(response.body);
      print(" oq tem aq ${data}");
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<List<TaskModel>> getTasks({required boardId}) async {
    try {
      prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('id');

      var url = 'http://10.0.2.2:3000/tasks/$userId/$boardId';

      var response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final List<dynamic> data = json.decode(response.body);
      final tasks = data.map((task) => TaskModel.fromJson(task)).toList();

      print("Temos 1 lista de task > ${tasks}");
      return tasks;
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  @override
  Future<List<BoardModel>> getBoards() async {
    try {
      prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('id');

      var url = 'http://10.0.2.2:3000/boards/$userId';

      var response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      final List<dynamic> data = json.decode(response.body);
      final tasks = data.map((task) => BoardModel.fromJson(task)).toList();

      print("Temos 1 lista de board > ${tasks}");
      return tasks;
    } catch (e) {
      log(e.toString());

      return [];
    }
  }

  @override
  Future<TaskModel> updateTask({
    required int id,
    required String title,
    required String description,
    required String status,
  }) async {
    try {
      prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('id');

      var url = 'http://10.0.2.2:3000/tasks/$id';

      var response = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'id': id,
          "title": title,
          "description": description,
          "status": status,
        }),
      );

      final data = json.decode(response.body);
      print(" oq tem aq ${data}");
      return TaskModel.fromJson(data);
    } catch (e) {
      log(e.toString());
      return TaskModel(
        id: id,
        title: title,
        description: description,
        status: status,
      );
    }
  }
}
