import 'package:flutter/material.dart';
import 'package:todo_app/model/task_list.dart';
import 'package:todo_app/screen/main_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final List<TaskList> _todo = taskList;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo App',
      home: MainScreen(todo: _todo),
    );
  }
}