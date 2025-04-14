import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/util/show_task_dialog.dart';

class TodoCard extends StatelessWidget {
  TodoCard({
    super.key,
    required this.task,
    required this.deadline,
    required this.isCompleted,
    required this.taskKey,
  });

  final Box<Task> _taskBox = Hive.box<Task>('taskBox');

  final String task;
  final DateTime deadline;
  bool isCompleted;
  final dynamic taskKey;

  final TextEditingController taskController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  // delete task
  void _deleteTask(BuildContext context) {
    _taskBox.delete(taskKey);
  }

  // edit task
  void _editTask(Task updatedTask) {
    _taskBox.put(taskKey, updatedTask);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[400],
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    task,
                    style: TextStyle(
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'Deadline: ${deadline.day}/${deadline.month}/${deadline.year}',
                    style: TextStyle(
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: () {
                taskController.text = task;
                dateController.text = "${deadline.toLocal()}".split(' ')[0];
                showTaskDialog(
                  context: context,
                  title: 'Add Task',
                  taskController: taskController,
                  dateController: dateController,
                  initialDate: DateTime.now(),
                  onSave: () {
                    if (taskController.text.isNotEmpty &&
                        dateController.text.isNotEmpty) {
                      final updatedTask = Task(
                        task: taskController.text,
                        deadline: DateTime.parse(dateController.text),
                        isCompleted: isCompleted ? true : false,
                      );
                      _editTask(updatedTask);
                    }
                  },
                );
              },
              icon: Icon(Icons.border_color_sharp, color: Colors.blue),
            ),
            IconButton(
              onPressed: () => _deleteTask(context),
              icon: Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
