import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/widget/todo_card.dart';
import 'package:todo_app/widget/form_button.dart';

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
        onPressed: () => _addDialog(context),
        backgroundColor: Colors.lime,
        child: Icon(Icons.add, color: Colors.indigo),
      ),
    );
  }

  Future<void> _addDialog(BuildContext context) {
    // Date and time variables
    DateTime selectedDate = DateTime.now();

    // Show date picker
    void _selectDate() async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != selectedDate) {
        selectedDate = picked;
        dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      }
    }

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: taskController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Task Name',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Select Deadline Date',
                  border: UnderlineInputBorder(),
                ),
                readOnly: true,
                onTap: () {
                  _selectDate();
                },
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
                    buttonFunction: () {
                      print(taskController.text);
                      if (taskController.text.isNotEmpty) {
                        final task = Task(
                          task: taskController.text,
                          deadline: selectedDate,
                        );
                        _addTask(task);
                        Navigator.pop(context);
                      }
                    },
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
