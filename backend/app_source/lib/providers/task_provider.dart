import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TaskProvider with ChangeNotifier {
  List<dynamic> _tasks = [];
  bool _isLoading = false;

  List<dynamic> get tasks => _tasks;
  bool get isLoading => _isLoading;

  Future<void> fetchTasks(int userId) async {
    _isLoading = true;
    notifyListeners();

    _tasks = await ApiService.getTasks(userId);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(int userId, String title) async {
    final result = await ApiService.addTask(userId, title);
    if (result['success'] == true) {
      // Refresh list
      await fetchTasks(userId);
    }
  }

  Future<void> toggleTask(int userId, int taskId, bool isCompleted) async {
    // Optimistic update
    final index = _tasks.indexWhere((t) => t['id'] == taskId);
    if (index != -1) {
      _tasks[index]['is_completed'] = isCompleted ? 1 : 0;
      notifyListeners();
    }

    await ApiService.updateTask(userId, taskId, isCompleted);
    // Could re-fetch to ensure sync, but optimistic is better UX
  }
}
