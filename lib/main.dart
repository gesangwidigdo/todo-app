import 'package:flutter/material.dart';
import 'package:todo_app/screen/main_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> todo = <String>['A', 'B', 'C'];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo App',
      home: MainScreen(todo: todo),
    );
  }
}