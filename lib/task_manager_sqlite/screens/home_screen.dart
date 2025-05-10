import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/task.dart';
import 'task_detail_screen.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Task>> _tasksFuture;
  String _currentFilter = 'Tất cả';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  void _refreshTasks() {
    setState(() {
      _tasksFuture = DatabaseHelper.instance.getAllTasks();
    });
  }

  Future<void> _logout() async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      Navigator.pushReplacementNamed(context, '/');

      // Hiển thị thông báo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã đăng xuất thành công')),
      );
    }
  }

  Future<void> _deleteTask(String id) async {
    await DatabaseHelper.instance.deleteTask(id);
    _refreshTasks();
  }

  Future<void> _toggleTaskComplete(Task task, bool completed) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      status: completed ? 'Done' : 'To do',
      priority: task.priority,
      dueDate: task.dueDate,
      createdAt: task.createdAt,
      updatedAt: DateTime.now(),
      assignedTo: task.assignedTo,
      createdBy: task.createdBy,
      category: task.category,
      attachments: task.attachments,
      completed: completed,
    );

    await DatabaseHelper.instance.updateTask(updatedTask);
    _refreshTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách công việc'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: _logout,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Làm mới',
            onPressed: _refreshTasks,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Tìm kiếm',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _refreshTasks();
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Tất cả', 'To do', 'In progress', 'Done'].map((filter) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FilterChip(
                    label: Text(filter),
                    selected: _currentFilter == filter,
                    onSelected: (selected) {
                      setState(() {
                        _currentFilter = selected ? filter : 'Tất cả';
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Task>>(
              future: _tasksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Không có công việc nào'));
                } else {
                  var tasks = snapshot.data!;


                  if (_currentFilter != 'Tất cả') {
                    tasks = tasks.where((t) => t.status == _currentFilter).toList();
                  }


                  if (_searchController.text.isNotEmpty) {
                    final keyword = _searchController.text.toLowerCase();
                    tasks = tasks.where((t) =>
                    t.title.toLowerCase().contains(keyword) ||
                        t.description.toLowerCase().contains(keyword)
                    ).toList();
                  }

                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ListTile(
                          title: Text(task.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Trạng thái: ${task.status}'),
                              if (task.dueDate != null)
                                Text('Hạn chót: ${task.dueDate!.toString().substring(0, 10)}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteTask(task.id),
                              ),
                              Checkbox(
                                value: task.completed,
                                onChanged: (value) => _toggleTaskComplete(task, value!),
                              ),
                            ],
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskDetailScreen(task: task),
                            ),
                          ).then((_) => _refreshTasks()),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddTaskScreen()),
        ).then((_) => _refreshTasks()),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}