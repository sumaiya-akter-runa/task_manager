enum TaskPriority {
  low('Low'),
  medium('Medium'),
  high('High');

  const TaskPriority(this.label);
  final String label;
}

class Task {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final TaskPriority priority;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.priority = TaskPriority.medium,
  });

  Task copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    TaskPriority? priority,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
    );
  }
}
