import 'package:flutter/material.dart';
import '../../../../../repositories/task/model/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final ValueChanged<String>? onStatusChanged;

  const TaskCard({super.key, required this.task, this.onStatusChanged});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'done':
        return Colors.green;
      case 'in_progress':
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'done':
        return 'Concluída';
      case 'in_progress':
        return 'Em Andamento';
      default:
        return 'A Realizar';
    }
  }

  void _showTaskDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text(
                task.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                task.description.isNotEmpty
                    ? task.description
                    : 'Sem descrição',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Alterar status:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  _statusButton(context, 'todo', 'A Realizar'),
                  _statusButton(context, 'in_progress', 'Em Andamento'),
                  _statusButton(context, 'done', 'Concluída'),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _statusButton(BuildContext context, String status, String label) {
    final bool isSelected = task.status == status;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? _getStatusColor(status) : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () {
        Navigator.pop(context);
        if (onStatusChanged != null) onStatusChanged!(status);
      },
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: () => _showTaskDetails(context),
        title: Text(
          task.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(task.description),
        trailing: Icon(
          Icons.circle,
          color: _getStatusColor(task.status),
          size: 14,
        ),
      ),
    );
  }
}
