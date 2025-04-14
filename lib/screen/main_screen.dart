import 'package:flutter/material.dart';
import 'package:todo_app/widget/todo_card.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.todo});

  final List<String> todo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo App', style: TextStyle(color: Colors.white70)),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: todo.length,
          itemBuilder: (context, index) {
            return TodoCard(todoItem: todo[index]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addDialog(context),
        backgroundColor: Colors.lime,
        child: Icon(Icons.add, color: Colors.indigo),
      ),
    );
  }

  Future<void> _addDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Task Name',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
