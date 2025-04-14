import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  const TodoCard({super.key, required this.todoItem});

  final String todoItem;

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
                    todoItem,
                    style: TextStyle(
                      fontSize: 16,
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
              onPressed: () {},
              icon: Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
