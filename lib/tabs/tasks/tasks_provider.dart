import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:notabox/firebase_funcations.dart';
import 'package:notabox/models/task_model.dart';

class TasksProvider with ChangeNotifier {
  List<TaskModel> tasks = [];
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;

  /// جلب جميع المهام من Firebase
  Future<void> getTasks(String userId, BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      List<TaskModel> allTasks =
          await FirebaseFuncations.getAllTasksFromFirestore(userId, context);

      tasks = allTasks
          .where((task) =>
              task.date.day == selectedDate.day &&
              task.date.month == selectedDate.month &&
              task.date.year == selectedDate.year)
          .toList();
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error fetching tasks: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// تغيير التاريخ المحدد
  void changeSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  /// إضافة مهمة جديدة إلى القائمة
  void addTask(TaskModel task) {
    tasks.add(task);
    notifyListeners();
  }

  /// تحديث حالة المهمة (إنجاز المهمة أو عدمها)
  Future<void> updateTaskStatus(
      String taskId, String userId, bool isDone, BuildContext context) async {
    try {
      await FirebaseFuncations.updateTaskStatus(
          taskId, userId, isDone, context);
      await getTasks(userId, context);
      Fluttertoast.showToast(
        msg: "Task status updated successfully",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error updating task: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  /// حذف المهمة
  Future<void> deleteTask(
      String taskId, String userId, BuildContext context) async {
    try {
      await FirebaseFuncations.deleteTaskFirestore(taskId, userId, context);
      await getTasks(userId, context);
      Fluttertoast.showToast(
        msg: "Task deleted successfully",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error deleting task: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}
