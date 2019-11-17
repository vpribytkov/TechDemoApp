import 'package:kiwi/kiwi.dart' as Injection;
import 'package:rx_command/rx_command.dart';

import 'package:tech_demo_app/data/task_repository.dart';
import 'package:tech_demo_app/data/task.dart';

abstract class TaskListModel {
  RxCommand<void, List<Task>> get commandLoad;
  RxCommand<Task, void> get commandRemove;
  RxCommand<Task, void> get commandUpdate;
  RxCommand<Task, void> get commandCreate;
}

class TaskListModelImpl implements TaskListModel {
  TaskListModelImpl() {
    TaskRepository repository = Injection.Container().resolve<TaskRepository>();

    _load = RxCommand.createAsyncNoParam(repository.readAll);

    _remove = RxCommand.createAsyncNoResult(repository.delete);
    _remove.listen((void _) => _load());

    _update = RxCommand.createAsyncNoResult(repository.update);
    _update.listen((void _) => _load());

    _create = RxCommand.createAsyncNoResult(repository.create);
    _create.listen((void _) => _load());

    _load();
  }

  @override RxCommand<void, List<Task>> get commandLoad => _load;
  @override RxCommand<Task, void> get commandRemove => _remove;
  @override RxCommand<Task, void> get commandCreate => _create;
  @override RxCommand<Task, void> get commandUpdate => _update;

  RxCommand<void, List<Task>> _load;
  RxCommand<Task, void> _remove;
  RxCommand<Task, void> _update;
  RxCommand<Task, void> _create;
}
