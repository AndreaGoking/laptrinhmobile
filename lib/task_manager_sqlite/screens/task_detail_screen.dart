import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  TaskDetailScreen({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chi tiết công việc')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(task.title, style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 16),
            Text('Mô tả:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(task.description),
            SizedBox(height: 16),
            Row(
              children: [
                Text('Trạng thái: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Chip(
                  label: Text(task.status),
                  backgroundColor: _getStatusColor(task.status),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text('Độ ưu tiên: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Chip(
                  label: Text(
                    task.priority == 1
                        ? 'Thấp'
                        : task.priority == 2
                        ? 'Trung bình'
                        : 'Cao',
                  ),
                  backgroundColor: _getPriorityColor(task.priority),
                ),
              ],
            ),
            SizedBox(height: 8),
            if (task.dueDate != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hạn chót:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(task.dueDate!.toString().substring(0, 10)),
                ],
              ),
            SizedBox(height: 16),
            Text('Ngày tạo:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(task.createdAt.toString().substring(0, 16)),
            SizedBox(height: 8),
            Text('Cập nhật lần cuối:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(task.updatedAt.toString().substring(0, 16)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'To do':
        return Colors.grey[300]!;
      case 'In progress':
        return Colors.blue[200]!;
      case 'Done':
        return Colors.green[200]!;
      default:
        return Colors.grey[300]!;
    }
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.green[200]!;
      case 2:
        return Colors.blue[200]!;
      case 3:
        return Colors.red[200]!;
      default:
        return Colors.grey[300]!;
    }
  }
}