import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import '../utils/priority_style.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  void _deleteWithUndo(BuildContext context) {
    final provider = context.read<TaskProvider>();
    final messenger = ScaffoldMessenger.of(context);

    provider.deleteTask(task.id);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Task deleted'),
          action: SnackBarAction(label: 'UNDO', onPressed: provider.undoDelete),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final done = task.isCompleted;

    // Entrance animation: fade + slide up.
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(offset: Offset(0, 30 * (1 - value)), child: child),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Dismissible(
            key: ValueKey('dismiss-${task.id}'),
            direction: DismissDirection.endToStart,
            onDismissed: (_) => _deleteWithUndo(context),
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 24),
              color: scheme.error,
              child: Icon(Icons.delete_rounded, color: scheme.onError),
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              color: done
                  ? scheme.surfaceContainerHighest.withOpacity(0.45)
                  : scheme.surfaceContainerHighest,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 6,
                      color: done ? scheme.outlineVariant : task.priority.color,
                    ),
                    const SizedBox(width: 6),
                    Center(
                      child: Checkbox(
                        value: done,
                        shape: const CircleBorder(),
                        onChanged: (_) =>
                            context.read<TaskProvider>().toggleTaskStatus(task.id),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: done ? 0.55 : 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 300),
                                style: textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: scheme.onSurface,
                                  decoration:
                                      done ? TextDecoration.lineThrough : TextDecoration.none,
                                ),
                                child: Text(task.title),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                task.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodyMedium
                                    ?.copyWith(color: scheme.onSurfaceVariant),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.flag_rounded,
                                      size: 14, color: task.priority.color),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${task.priority.label} priority',
                                    style: textTheme.labelSmall
                                        ?.copyWith(color: task.priority.color),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Delete task',
                      icon: Icon(Icons.delete_outline_rounded, color: scheme.error),
                      onPressed: () => _deleteWithUndo(context),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
