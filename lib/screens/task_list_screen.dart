import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../utils/app_routes.dart';
import '../widgets/empty_state.dart';
import '../widgets/filter_bar.dart';
import '../widgets/task_statistics.dart';
import '../widgets/task_tile.dart';
import 'add_task_screen.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: const [_ClearCompletedButton()],
      ),
      body: const Column(
        children: [
          TaskStatistics(),
          FilterBar(),
          Expanded(child: _TaskListSection()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(buildSlideUpRoute(const AddTaskScreen())),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Task'),
      ),
    );
  }
}

class _TaskListSection extends StatelessWidget {
  const _TaskListSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, _) {
        final tasks = taskProvider.visibleTasks;

        Widget content;
        if (taskProvider.totalTasks == 0) {
          content = const EmptyState(
            key: ValueKey('empty-all'),
            icon: Icons.task_alt_rounded,
            title: 'No tasks yet',
            message: 'Tap "Add Task" to create your first one.',
          );
        } else if (tasks.isEmpty) {
          final isPending = taskProvider.filter == TaskFilter.pending;
          content = EmptyState(
            key: ValueKey('empty-${taskProvider.filter.name}'),
            icon: isPending ? Icons.celebration_rounded : Icons.inbox_rounded,
            title: isPending ? 'All caught up!' : 'Nothing completed yet',
            message: isPending
                ? 'You have no pending tasks. Great job!'
                : 'Complete a task and it will show up here.',
          );
        } else {
          content = ListView.builder(
            key: ValueKey('list-${taskProvider.filter.name}'),
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskTile(key: ValueKey(task.id), task: task);
            },
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 320),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: content,
        );
      },
    );
  }
}

class _ClearCompletedButton extends StatelessWidget {
  const _ClearCompletedButton();

  @override
  Widget build(BuildContext context) {
    return Selector<TaskProvider, int>(
      selector: (_, provider) => provider.completedTasks,
      builder: (context, completedCount, _) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) => ScaleTransition(
            scale: animation,
            child: FadeTransition(opacity: animation, child: child),
          ),
          child: completedCount > 0
              ? IconButton(
            key: const ValueKey('clear-visible'),
            tooltip: 'Clear completed',
            icon: const Icon(Icons.cleaning_services_rounded),
            onPressed: () {
              context.read<TaskProvider>().clearCompleted();
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Completed tasks cleared')),
                );
            },
          )
              : const SizedBox.shrink(key: ValueKey('clear-hidden')),
        );
      },
    );
  }
}