import '../util/task_specific_to_planting_enum.dart';
import '../util/task_status_enum.dart';

class Task {
  String taskDate;
  TaskStatus taskStatus;
  String taskName;
  String fieldName;
  TaskSpecificToPlanting taskSpecificToPlanting;
  String? plantingName;
  String? notes;
  Task({
    required this.taskDate,
    required this.taskStatus,
    required this.taskName,
    required this.fieldName,
    required this.taskSpecificToPlanting,
    this.plantingName,
    this.notes,
  });
  Map<String, dynamic> getTaskDataMap() {
    return {
      'taskDate': taskDate,
      'taskStatus': taskStatus.toString().split('.').last, // Convert to String
      'taskName': taskName,
      'fieldName': fieldName,
      'taskSpecificToPlanting': taskSpecificToPlanting.toString().split('.').last, // Convert to String
      'plantingName': plantingName,
      'notes': notes,
    };
  }
}
