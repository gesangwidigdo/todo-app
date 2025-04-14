import 'package:flutter/material.dart';
import 'package:todo_app/widget/form_button.dart';

Future<void> showTaskDialog({
  required BuildContext context,
  required String title,
  required TextEditingController taskController,
  required TextEditingController dateController,
  required DateTime initialDate,
  required VoidCallback onSave,
}) async {
  // Date and time variables
  DateTime selectedDate = initialDate;

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

  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
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
                  buttonText: 'Save',
                  backgroundColor: Colors.green,
                  buttonFunction: () {
                    onSave();
                    Navigator.pop(context);
                    taskController.clear();
                    dateController.clear();
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
