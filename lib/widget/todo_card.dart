import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/model/task.dart';

class TodoCard extends StatelessWidget {
  TodoCard({
    super.key,
    required this.task,
    required this.deadline,
    required this.taskKey,
  });

  final Box<Task> _taskBox = Hive.box<Task>('taskBox');

  final String task;
  final DateTime deadline;
  final dynamic taskKey;

  void _deleteTask(BuildContext context) {
    _taskBox.delete(taskKey);
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
              onPressed: () {},
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
