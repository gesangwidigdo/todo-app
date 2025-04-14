class TaskList {
  String task;
  DateTime deadline;

  TaskList({required this.task, required this.deadline});

}
  var taskList = [
    TaskList(task: 'A', deadline: DateTime.now()),
    TaskList(task: 'B', deadline: DateTime.now()),
    TaskList(task: 'C', deadline: DateTime.now()),
  ];
