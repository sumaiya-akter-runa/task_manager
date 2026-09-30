import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';

class FilterBar extends StatelessWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final selected = context.select<TaskProvider, TaskFilter>((p) => p.filter);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: SizedBox(
        width: double.infinity,
        child: SegmentedButton<TaskFilter>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(value: TaskFilter.all, label: Text('All')),
            ButtonSegment(value: TaskFilter.pending, label: Text('Pending')),
            ButtonSegment(value: TaskFilter.completed, label: Text('Completed')),
          ],
          selected: {selected},
          onSelectionChanged: (values) =>
              context.read<TaskProvider>().setFilter(values.first),
        ),
      ),
    );
  }
}
