import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:impacta_project/app/features/home/modules/tasks/cubit/task_bloc_state.dart';
import 'package:impacta_project/app/features/home/modules/tasks/task_open_page.dart';
import 'package:impacta_project/app/features/home/modules/tasks/task_page.dart';

import '../../core/messages.dart';
import '../profile/profile_page.dart';
import 'modules/tasks/cubit/task_bloc_cubit.dart';
import 'modules/tasks/task_done_page.dart';

class HomePage extends StatefulWidget {
  final String board;
  final int boardId;
  const HomePage({required this.board, required this.boardId, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with Messages<HomePage> {
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<Widget> get _children => [
    Dashboard(boardId: widget.boardId),
    ProfilePage(),
  ];

  void _openCreateTaskModal() {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Nova Tarefa',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      child: const Text('Cancelar'),
                      onTap: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      child: const Text('Salvar'),
                      onPressed: () async {
                        if (titleController.text.isNotEmpty) {
                          await context.read<TaskBlocCubit>().createTask(
                            title: titleController.text,
                            description: descController.text,
                            boardId: widget.boardId,
                          );
                          await context.read<TaskBlocCubit>().getTask(
                            boardId: widget.boardId,
                          );
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.board),
        leading: IconButton(
          onPressed: () {
            Get.offAllNamed("/home_board");
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateTaskModal,
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        fixedColor: Colors.blue,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: _children[_currentIndex],
    );
  }
}

class Dashboard extends StatefulWidget {
  final int boardId;
  const Dashboard({required this.boardId, super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with Messages<Dashboard> {
  final tabs = [
    "Tarefas a realizar",
    "Tarefas em Aberto",
    "Tarefas Concluídas",
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTasks();
  }

  getTasks() async {
    await context.read<TaskBlocCubit>().getTask(boardId: widget.boardId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskBlocCubit, TaskBlocState>(
      listener: (context, state) {
        state.status.matchAny(
          success: () async {
            showSuccess(state.successMessage ?? "Tarefa criada com sucesso");
            //Get.offAllNamed("/home");
          },
          error: () {
            showError(state.errorMessage ?? "Erro não informado");
          },
          any: () {},
        );
      },
      buildWhen: (previous, current) => current.status != previous.status,
      listenWhen: (previous, current) => current.status != previous.status,
      builder: (context, state) {
        return DefaultTabController(
          length: tabs.length,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      child: TabBar(
                        isScrollable: true,
                        labelPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        indicator: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Colors.white,
                        dividerColor: Colors.transparent,
                        tabs: tabs.map((title) => Tab(text: title)).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TabBarView(
                      children: [
                        TaskPage(
                          key: ValueKey(state.task.hashCode),
                          task: state.task,
                        ),
                        TaskOpenPage(
                          key: ValueKey(state.task.hashCode),
                          task: state.task,
                        ),
                        TaskDonePage(
                          key: ValueKey(state.task.hashCode),
                          task: state.task,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
