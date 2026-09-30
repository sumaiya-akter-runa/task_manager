import 'package:flutter/material.dart';

import '../models/task.dart';

extension TaskPriorityStyle on TaskPriority {
  Color get color {
    switch (this) {
      case TaskPriority.low:
        return const Color(0xFF2E9E6B);
      case TaskPriority.medium:
        return const Color(0xFFF2A100);
      case TaskPriority.high:
        return const Color(0xFFE5484D);
    }
  }
}
