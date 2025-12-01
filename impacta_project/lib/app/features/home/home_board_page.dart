import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:impacta_project/app/features/home/modules/tasks/cubit/task_bloc_state.dart';

import '../../core/messages.dart';
import '../profile/profile_page.dart';
import 'modules/tasks/cubit/task_bloc_cubit.dart';
import 'modules/tasks/widget/board_card_widget.dart';

class HomeBoardPage extends StatefulWidget {
  const HomeBoardPage({super.key});

  @override
  State<HomeBoardPage> createState() => _HomeBoardPageState();
}

class _HomeBoardPageState extends State<HomeBoardPage>
    with Messages<HomeBoardPage> {
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _children = [DashBoardTask(), ProfilePage()];
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
                  'Nova Projeto',
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
                          await context.read<TaskBlocCubit>().createBoard(
                            title: titleController.text,
                            description: descController.text,
                          );
                          await context.read<TaskBlocCubit>().getBoard();
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
        title: Text(
          "Board",
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue,
      ),
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
      backgroundColor: Colors.white,
      body: _children[_currentIndex],
    );
  }
}

class DashBoardTask extends StatefulWidget {
  const DashBoardTask({super.key});

  @override
  State<DashBoardTask> createState() => _DashBoardTaskState();
}

class _DashBoardTaskState extends State<DashBoardTask>
    with Messages<DashBoardTask> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBoard();
  }

  void getBoard() async {
    await context.read<TaskBlocCubit>().getBoard();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskBlocCubit, TaskBlocState>(
      listener: (context, state) {
        state.status.matchAny(
          success: () async {
            showSuccess(state.successMessage ?? "");
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
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(children: [BoardCardWidget(task: state.board)]),
          ),
        );
      },
    );
  }
}
