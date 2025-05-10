import 'package:flutter/material.dart';
import '../models/task.dart';
import '../db/database_helper.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;
  String _status = 'To do';
  int _priority = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thêm công việc mới')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Tiêu đề'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tiêu đề';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Mô tả'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mô tả';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status,
                items: ['To do', 'In progress', 'Done']
                    .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Trạng thái'),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _priority,
                items: [1, 2, 3]
                    .map((priority) => DropdownMenuItem(
                  value: priority,
                  child: Text(
                    priority == 1
                        ? 'Thấp'
                        : priority == 2
                        ? 'Trung bình'
                        : 'Cao',
                  ),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Độ ưu tiên'),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(_dueDate == null
                      ? 'Chưa chọn ngày hết hạn'
                      : 'Hạn chót: ${_dueDate!.toString().substring(0, 10)}'),
                  TextButton(
                    onPressed: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          _dueDate = selectedDate;
                        });
                      }
                    },
                    child: Text('Chọn ngày'),
                  ),
                ],
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveTask,
                child: Text('Lưu công việc'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        status: _status,
        priority: _priority,
        dueDate: _dueDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        assignedTo: null,
        createdBy: 'current_user_id',
        category: null,
        attachments: null,
        completed: false,
      );

      await DatabaseHelper.instance.createTask(newTask);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}