import 'package:flutter/material.dart';

/// Empty-state with a scale/fade entrance and a gently floating icon.
/// StatefulWidget is used only for the animation controller.
class EmptyState extends StatefulWidget {
  final IconData icon;
  final String title;
  final String message;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  State<EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<EmptyState> with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;
  late final Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _floatAnimation = CurvedAnimation(parent: _floatController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutBack,
        builder: (context, value, child) => Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: Transform.scale(scale: 0.8 + 0.2 * value, child: child),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _floatAnimation,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, -12 * _floatAnimation.value),
                child: child,
              ),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.primaryContainer.withOpacity(0.6),
                ),
                child: Icon(widget.icon, size: 64, color: scheme.primary),
              ),
            ),
            const SizedBox(height: 24),
            Text(widget.title,
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                widget.message,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
