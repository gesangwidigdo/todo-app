import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String task;

  @HiveField(1)
  DateTime deadline;

  @HiveField(2)
  bool isCompleted;

  Task({required this.task, required this.deadline, required this.isCompleted});
}
