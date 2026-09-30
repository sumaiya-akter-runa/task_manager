import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';

class TaskStatistics extends StatelessWidget {
  const TaskStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final percent = (provider.completionRatio * 100).round();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [scheme.primary, Color.lerp(scheme.primary, scheme.tertiary, 0.6)!],
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withOpacity(0.3),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Your progress',
                  style: textTheme.titleMedium?.copyWith(
                    color: scheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _AnimatedCount(
                value: percent,
                suffix: '%',
                style: textTheme.headlineSmall!.copyWith(
                  color: scheme.onPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: provider.completionRatio),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: scheme.onPrimary.withOpacity(0.25),
                valueColor: AlwaysStoppedAnimation(scheme.onPrimary),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _StatItem(label: 'Total', value: provider.totalTasks, icon: Icons.list_alt_rounded),
              _StatItem(
                  label: 'Completed',
                  value: provider.completedTasks,
                  icon: Icons.check_circle_rounded),
              _StatItem(
                  label: 'Pending',
                  value: provider.pendingTasks,
                  icon: Icons.schedule_rounded),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;

  const _StatItem({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: scheme.onPrimary.withOpacity(0.85), size: 22),
          const SizedBox(height: 4),
          _AnimatedCount(
            value: value,
            style: textTheme.titleLarge!.copyWith(
              color: scheme.onPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(color: scheme.onPrimary.withOpacity(0.85)),
          ),
        ],
      ),
    );
  }
}

/// Counts smoothly from the previous number to the new one.
class _AnimatedCount extends StatelessWidget {
  final int value;
  final String suffix;
  final TextStyle style;

  const _AnimatedCount({required this.value, required this.style, this.suffix = ''});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, current, _) => Text('$current$suffix', style: style),
    );
  }
}
