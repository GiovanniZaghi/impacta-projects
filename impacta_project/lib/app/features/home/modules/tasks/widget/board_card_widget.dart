import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:impacta_project/app/repositories/task/model/board_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoardCardWidget extends StatefulWidget {
  List<BoardModel> task;
  BoardCardWidget({required this.task, super.key});

  @override
  State<BoardCardWidget> createState() => _BoardCardWidgetState();
}

class _BoardCardWidgetState extends State<BoardCardWidget> {
  String _selectedTab = 'todo';
  bool _isLoading = true;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Text(
            "Meus projetos",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 25),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : widget.task.isEmpty
              ? const Center(child: Text('Nenhuma tarefa encontrada'))
              : RefreshIndicator(
                onRefresh: _loadTasks,
                child: Column(
                  children:
                      widget.task.map((e) {
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            onTap: () async {
                              Get.offAndToNamed(
                                "/home",
                                arguments: {
                                  "id": e.id,
                                  "name": e.name,
                                  "tasks": e.tasks,
                                },
                              );
                            },
                            title: Text(
                              e.name ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
        ],
      ),
    );
  }
}
