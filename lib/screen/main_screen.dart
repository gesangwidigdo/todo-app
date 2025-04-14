import 'package:flutter/material.dart';
import 'package:todo_app/model/task_list.dart';
import 'package:todo_app/widget/todo_card.dart';
import 'package:todo_app/widget/form_button.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.todo});

  final List<TaskList> todo;

  // add data
  void _addTask() {
    // 
  }

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
            taskList.sort((a, b) => b.deadline.compareTo(a.deadline));
            final _taskItem = taskList[index];
            return TodoCard(task: _taskItem.task, deadline: _taskItem.deadline);
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FormButton(
                    buttonText: 'Cancel',
                    backgroundColor: Colors.red,
                    buttonFunction: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  FormButton(
                    buttonText: 'Add',
                    backgroundColor: Colors.green,
                    buttonFunction: () {},
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}