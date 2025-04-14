import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String task;

  @HiveField(1)
  DateTime deadline;

  Task({required this.task, required this.deadline});

}
