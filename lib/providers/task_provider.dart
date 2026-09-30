import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../models/task.dart';

enum TaskFilter { all, pending, completed }

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [];
  TaskFilter _filter = TaskFilter.all;

  Task? _lastDeletedTask;
  int _lastDeletedIndex = 0;

  UnmodifiableListView<Task> get tasks => UnmodifiableListView(_tasks);
  TaskFilter get filter => _filter;

  List<Task> get visibleTasks {
    switch (_filter) {
      case TaskFilter.all:
        return tasks;
      case TaskFilter.pending:
        return _tasks.where((task) => !task.isCompleted).toList();
      case TaskFilter.completed:
        return _tasks.where((task) => task.isCompleted).toList();
    }
  }

  int get totalTasks => _tasks.length;
  int get completedTasks => _tasks.where((task) => task.isCompleted).length;
  int get pendingTasks => totalTasks - completedTasks;
  double get completionRatio => totalTasks == 0 ? 0 : completedTasks / totalTasks;

  void addTask({
    required String title,
    required String description,
    TaskPriority priority = TaskPriority.medium,
  }) {
    _tasks.insert(
      0,
      Task(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title.trim(),
        description: description.trim(),
        priority: priority,
      ),
    );
    notifyListeners();
  }

  void toggleTaskStatus(String taskId) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index == -1) return;
    _tasks[index] = _tasks[index].copyWith(isCompleted: !_tasks[index].isCompleted);
    notifyListeners();
  }

  void deleteTask(String taskId) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index == -1) return;
    _lastDeletedTask = _tasks[index];
    _lastDeletedIndex = index;
    _tasks.removeAt(index);
    notifyListeners();
  }

  void undoDelete() {
    final task = _lastDeletedTask;
    if (task == null) return;
    _tasks.insert(_lastDeletedIndex.clamp(0, _tasks.length), task);
    _lastDeletedTask = null;
    notifyListeners();
  }

  void clearCompleted() {
    _tasks.removeWhere((task) => task.isCompleted);
    notifyListeners();
  }

  void setFilter(TaskFilter newFilter) {
    if (_filter == newFilter) return;
    _filter = newFilter;
    notifyListeners();
  }
}
