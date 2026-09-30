import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import '../utils/priority_style.dart';

/// StatefulWidget only owns/disposes controllers. No setState() is used
/// and no task data is stored here.
class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priority = ValueNotifier<TaskPriority>(TaskPriority.medium);

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priority.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<TaskProvider>().addTask(
          title: _titleController.text,
          description: _descriptionController.text,
          priority: _priority.value,
        );
    Navigator.of(context).pop();
  }

  String? _required(String? value, String message) =>
      (value == null || value.trim().isEmpty) ? message : null;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('New Task')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _FadeInSection(
              delay: 0,
              child: TextFormField(
                controller: _titleController,
                autofocus: true,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  prefixIcon: Icon(Icons.title_rounded),
                ),
                validator: (v) => _required(v, 'Please enter a title'),
              ),
            ),
            const SizedBox(height: 16),
            _FadeInSection(
              delay: 1,
              child: TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 64),
                    child: Icon(Icons.notes_rounded),
                  ),
                ),
                validator: (v) => _required(v, 'Please enter a description'),
              ),
            ),
            const SizedBox(height: 24),
            _FadeInSection(
              delay: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Priority', style: textTheme.titleSmall),
                  const SizedBox(height: 8),
                  ValueListenableBuilder<TaskPriority>(
                    valueListenable: _priority,
                    builder: (context, selected, _) {
                      return SizedBox(
                        width: double.infinity,
                        child: SegmentedButton<TaskPriority>(
                          showSelectedIcon: false,
                          segments: TaskPriority.values
                              .map(
                                (p) => ButtonSegment(
                                  value: p,
                                  label: Text(p.label),
                                  icon: Icon(Icons.flag_rounded, color: p.color, size: 18),
                                ),
                              )
                              .toList(),
                          selected: {selected},
                          onSelectionChanged: (s) => _priority.value = s.first,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _FadeInSection(
              delay: 3,
              child: SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Save Task'),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Staggered fade + slide-in for form sections.
class _FadeInSection extends StatelessWidget {
  final int delay;
  final Widget child;

  const _FadeInSection({required this.delay, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + delay * 120),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(offset: Offset(0, 24 * (1 - value)), child: child),
      ),
      child: child,
    );
  }
}
