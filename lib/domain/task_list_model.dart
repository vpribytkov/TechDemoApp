import 'package:kiwi/kiwi.dart' as Injection;
import 'package:rx_command/rx_command.dart';
import 'package:rxdart/rxdart.dart';

import 'package:tech_demo_app/data/task_repository.dart';
import 'package:tech_demo_app/data/task.dart';

enum SortOrder {
  Ascending,
  Descending
}

enum SortCriterion {
  CreationDate,
  ExpirationDate,
  Priority
}

class TaskListInfo
{
  TaskListInfo({ this.data, this.hasError, this.error, this.loading });

  List<Task> data;
  bool hasError;
  String error;
  bool loading;
}

abstract class TaskListModel {
  Observable<TaskListInfo> get tasks;
  Observable<SortOrder> get sortOrder;
  Observable<SortCriterion> get sortCriterion;

  RxCommand<Task, void> get commandRemove;
  RxCommand<Task, void> get commandUpdate;
  RxCommand<Task, void> get commandCreate;

  Future<void> load();
  void sort({ SortOrder order, SortCriterion criterion });
}

class TaskListModelImpl implements TaskListModel {
  TaskListModelImpl() {
    _tasks = BehaviorSubject<TaskListInfo>.seeded(
      TaskListInfo(
        data: [],
        error: null,
        loading: false
      )
    );

    _remove = RxCommand.createAsyncNoResult(_repository().delete);
    _remove.listen((void _) async => await _loadAndSort());

    _update = RxCommand.createAsyncNoResult(_repository().update);
    _update.listen((void _) async => await _loadAndSort());

    _create = RxCommand.createAsyncNoResult(_repository().create);
    _create.listen((void _) async => await _loadAndSort());

    load();
  }

  @override Observable<TaskListInfo> get tasks => _tasks.stream;
  @override Observable<SortOrder> get sortOrder => _sortOrder.stream;
  @override Observable<SortCriterion> get sortCriterion => _sortCriterion.stream;

  @override RxCommand<Task, void> get commandRemove => _remove;
  @override RxCommand<Task, void> get commandCreate => _create;
  @override RxCommand<Task, void> get commandUpdate => _update;

  @override
  Future<void> load() async
  {
    _updateTaskListInfo(_tasks.value.data, _tasks.value.hasError, _tasks.value.error, true);

    try {
      List<Task> tasks = await _repository().readAll();

      _updateTaskListInfo(tasks, false, null, false);
    }
    catch (ex) {
      _updateTaskListInfo([], true, ex, false);
    }
  }

  @override
  void sort({ SortOrder order, SortCriterion criterion })
  {
    if (order != null) {
      _sortOrder.add(order);
    }

    if (criterion != null) {
      _sortCriterion.add(criterion);
    }

    var sorted = List<Task>.from(_tasks.value.data);
    sorted.sort((Task left, Task right) {
      final order = _sortOrder.value;
      final criterion = _sortCriterion.value;

      if (criterion == SortCriterion.CreationDate) {
        return order == SortOrder.Ascending
          ? left.creationDate.compareTo(right.creationDate)
          : right.creationDate.compareTo(left.creationDate);
      }

      if (criterion == SortCriterion.ExpirationDate) {
        return order == SortOrder.Ascending
            ? left.expirationDate.compareTo(right.expirationDate)
            : right.expirationDate.compareTo(left.expirationDate);
      }

      return order == SortOrder.Ascending
        ? left.priority.index - right.priority.index
        : right.priority.index - left.priority.index;
    });
    _updateTaskListInfo(sorted, _tasks.value.hasError, _tasks.value.error, false);
  }

  Future<void> _loadAndSort() async {
    await load();
    sort();
  }

  TaskRepository _repository()
  {
    return Injection.Container().resolve<TaskRepository>();
  }

  void _updateTaskListInfo(data, hasError, error, loading) {
    _tasks.add(TaskListInfo(data: data, hasError: hasError, error: error, loading: loading));
  }

  BehaviorSubject<TaskListInfo> _tasks;
  BehaviorSubject<SortOrder> _sortOrder = BehaviorSubject<SortOrder>.seeded(SortOrder.Descending);
  BehaviorSubject<SortCriterion> _sortCriterion = BehaviorSubject<SortCriterion>.seeded(SortCriterion.CreationDate);

  RxCommand<Task, void> _remove;
  RxCommand<Task, void> _update;
  RxCommand<Task, void> _create;
}
