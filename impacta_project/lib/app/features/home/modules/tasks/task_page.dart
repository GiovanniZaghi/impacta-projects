import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:impacta_project/app/features/home/modules/tasks/cubit/task_bloc_cubit.dart';
import 'package:impacta_project/app/features/home/modules/tasks/widget/task_card_widget.dart';

import '../../../../repositories/task/model/task_model.dart';

class TaskPage extends StatefulWidget {
  List<TaskModel> task;
  TaskPage({required this.task, super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  String _selectedTab = 'todo';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    //final tasks = await _taskService.getTasks(1);
    setState(() {
      //_tasks = tasks;
      _isLoading = false;
    });
  }

  void _updateTaskStatus(TaskModel task, String newStatus) {
    widget.task.map((t) async {
      if (t.id == task.id) {
        await context.read<TaskBlocCubit>().updateTask(
          id: t.id,
          status: newStatus,
          title: t.title,
          description: t.description,
        );
      }
      return t;
    }).toList();
    Get.offAllNamed("/home");
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks =
        widget.task.where((t) => t.status == _selectedTab).toList();

    return Scaffold(
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : filteredTasks.isEmpty
              ? const Center(child: Text('Nenhuma tarefa encontrada'))
              : RefreshIndicator(
                onRefresh: _loadTasks,
                child: ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    return TaskCard(
                      task: task,
                      onStatusChanged:
                          (newStatus) => _updateTaskStatus(task, newStatus),
                    );
                  },
                ),
              ),
    );
  }
}
