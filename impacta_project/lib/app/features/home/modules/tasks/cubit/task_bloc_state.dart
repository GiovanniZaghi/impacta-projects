import 'package:equatable/equatable.dart';
import 'package:impacta_project/app/repositories/task/model/board_model.dart';
import 'package:match/match.dart';

import '../../../../../repositories/task/model/task_model.dart';

part 'task_bloc_state.g.dart';

@match
enum TaskStateStatus { initial, loading, error, success }

class TaskBlocState extends Equatable {
  final TaskStateStatus status;
  final String? errorMessage;
  final String? successMessage;
  final List<TaskModel> task;
  final List<BoardModel> board;

  const TaskBlocState({
    required this.status,
    this.errorMessage,
    this.successMessage,
    required this.task,
    required this.board,
  });

  TaskBlocState.initial()
    : status = TaskStateStatus.initial,
      errorMessage = null,
      successMessage = null,
      task = [],
      board = [];

  @override
  List<Object?> get props => [status, errorMessage, successMessage];

  TaskBlocState copyWith({
    TaskStateStatus? status,
    String? errorMessage,
    String? successMessage,
    List<TaskModel>? task,
    List<BoardModel>? board,
  }) {
    return TaskBlocState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      task: task ?? this.task,
      board: board ?? this.board,
    );
  }
}
