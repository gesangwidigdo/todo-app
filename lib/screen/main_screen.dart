import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/util/show_task_dialog.dart';
import 'package:todo_app/widget/todo_card.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final Box<Task> _taskBox = Hive.box<Task>('taskBox');

  final TextEditingController taskController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  // add data
  void _addTask(Task task) {
    final key = 'key_${DateTime.now().millisecondsSinceEpoch}';
    _taskBox.put(key, task);
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
        child: ValueListenableBuilder(
          valueListenable: _taskBox.listenable(),
          builder: (context, Box<Task> box, _) {
            // Listen for changes in the box and rebuild the UI
            final taskList = box.values.toList();

            return ListView.builder(
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                final task = taskList[index];
                final _taskKey = _taskBox.keyAt(index);
                return TodoCard(
                  task: task.task,
                  deadline: task.deadline,
                  taskKey: _taskKey,
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => showTaskDialog(
              context: context,
              title: 'Add Task',
              taskController: taskController,
              dateController: dateController,
              initialDate: DateTime.now(),
              onSave: () {
                if (taskController.text.isNotEmpty) {
                  final task = Task(
                    task: taskController.text,
                    deadline: DateTime.parse(dateController.text),
                  );
                  _addTask(task);
                }
              },
            ),
        backgroundColor: Colors.lime,
        child: Icon(Icons.add, color: Colors.indigo),
      ),
    );
  }
}
