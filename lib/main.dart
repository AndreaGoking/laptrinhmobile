import 'package:app_02/task_manager_sqlite/screens/add_task_screen.dart';
import 'package:app_02/task_manager_sqlite/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_02/task_manager_sqlite/screens/login_screen.dart';
import 'package:app_02/task_manager_sqlite/db/database_helper.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();


  await DatabaseHelper.instance.database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager - Ngọc Quân',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: LoginScreen(),

      routes: {

        '/home': (context) => HomeScreen(),
        '/add-task': (context) => AddTaskScreen(),
      },
    );
  }
}