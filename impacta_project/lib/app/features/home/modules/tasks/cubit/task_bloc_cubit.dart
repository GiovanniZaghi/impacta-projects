import 'package:bloc/bloc.dart';
import 'package:impacta_project/app/features/home/modules/tasks/cubit/task_bloc_state.dart';

import '../../../../../repositories/task/task_repository.dart';

class TaskBlocCubit extends Cubit<TaskBlocState> {
  final TaskRepository taskRepository;
  TaskBlocCubit({required this.taskRepository})
    : super(TaskBlocState.initial());

  Future<void> createTask({
    required String title,
    required String description,
    required int boardId,
  }) async {
    try {
      emit(state.copyWith(status: TaskStateStatus.loading));
      await taskRepository.createTask(
        title: title,
        description: description,
        boardId: boardId,
      );
      final task = await taskRepository.getTasks(boardId: boardId);
      emit(
        state.copyWith(
          status: TaskStateStatus.success,
          errorMessage: "Tarefa criada com sucesso!! ",
          task: task,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: TaskStateStatus.error,
          errorMessage: "Erro ao cadastrar",
        ),
      );
    }
  }

  Future<void> createBoard({
    required String title,
    required String description,
  }) async {
    try {
      emit(state.copyWith(status: TaskStateStatus.loading));
      await taskRepository.createBoard(title: title);
      emit(
        state.copyWith(
          status: TaskStateStatus.success,
          errorMessage: "Projeto criado com sucesso!! ",
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: TaskStateStatus.error,
          errorMessage: "Erro ao cadastrar",
        ),
      );
    }
  }

  Future<void> getTask({required boardId}) async {
    try {
      emit(state.copyWith(status: TaskStateStatus.loading));
      print("Id do board no cubit > ${boardId}");
      final task = await taskRepository.getTasks(boardId: boardId);
      emit(
        state.copyWith(
          status: TaskStateStatus.success,
          successMessage: "Sucesso ao buscar tarefas",
          task: task,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: TaskStateStatus.error,
          errorMessage: "Erro ao buscar tarefas",
        ),
      );
    }
  }

  Future<void> updateTask({
    required int id,
    required String title,
    required String description,
    required String status,
  }) async {
    try {
      emit(state.copyWith(status: TaskStateStatus.loading));
      final task = await taskRepository.updateTask(
        id: id,
        title: title,
        description: description,
        status: status,
      );
      emit(
        state.copyWith(
          status: TaskStateStatus.success,
          successMessage: "Tarefa atualizada com sucesso!! ",
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: TaskStateStatus.error,
          errorMessage: "Erro ao atualizar",
        ),
      );
    }
  }

  Future<void> getBoard() async {
    try {
      emit(state.copyWith(status: TaskStateStatus.loading));
      final board = await taskRepository.getBoards();
      print("Oq temos no cubit ${board}");
      emit(
        state.copyWith(
          status: TaskStateStatus.success,
          successMessage: "Sucesso ao buscar board",
          board: board,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: TaskStateStatus.error,
          errorMessage: "Erro ao buscar tarefas",
        ),
      );
    }
  }
}
