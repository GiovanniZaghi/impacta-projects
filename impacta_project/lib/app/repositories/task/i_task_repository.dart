import 'model/task_model.dart';

abstract class ITaskRepository {
  Future<List<TaskModel>> getTasks({required boardId});
}
