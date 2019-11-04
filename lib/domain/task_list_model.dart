import 'package:kiwi/kiwi.dart' as Injection;
import 'package:rx_command/rx_command.dart';

import 'package:tech_demo_app/data/task_repository.dart';
import 'package:tech_demo_app/data/task.dart';

abstract class TaskListModel {
  RxCommand<void, List<Task>> loadObservable();
  void loadTasks();

  RxCommand<Task, void> removeObservable();
  void removeTask(Task task);
}

class TaskListModelImpl implements TaskListModel {
  TaskListModelImpl() {
    TaskRepository repository = Injection.Container().resolve<TaskRepository>();

    _loadCommand = RxCommand.createAsyncNoParam(repository.readAll);
    _removeCommand = RxCommand.createAsyncNoResult(repository.delete);

    loadTasks();
  }

  @override
  RxCommand<void, List<Task>> loadObservable() {
    return _loadCommand;
  }

  @override
  void loadTasks() {
    _loadCommand.execute();
  }

  @override
  RxCommand<Task, void> removeObservable() {
    return _removeCommand;
  }

  @override
  void removeTask(Task task) {
    _removeCommand.execute(task);

    loadTasks();
  }

  RxCommand<void, List<Task>> _loadCommand;
  RxCommand<Task, void> _removeCommand;
}
