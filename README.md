# Task Manager (Flutter + Provider)

## Setup
```bash
flutter create task_manager
cd task_manager
flutter pub add provider
# replace the generated lib/ folder with the lib/ folder from this project
flutter run
```

## Structure
```
lib/
├── main.dart                     # ChangeNotifierProvider setup
├── models/task.dart              # Task model
├── providers/task_provider.dart  # TaskProvider (ChangeNotifier)
├── screens/
│   ├── task_list_screen.dart     # AppBar, stats, ListView.builder, FAB
│   └── add_task_screen.dart      # Add task form
└── widgets/
    ├── task_tile.dart            # Checkbox + delete
    ├── task_statistics.dart      # Total / Completed / Pending
    └── empty_state.dart          # Empty-state UI
```
