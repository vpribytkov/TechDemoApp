import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:kiwi/kiwi.dart' as Injection;
import 'package:rx_command/rx_command.dart';

import 'package:tech_demo_app/app_drawer.dart';
import 'package:tech_demo_app/data/task.dart';
import 'package:tech_demo_app/domain/task_list_model.dart';
import 'package:tech_demo_app/view/task_view.dart';

class DashboardView extends StatelessWidget {
  static const routeName = "dashboard_view";

  @override
  Widget build(BuildContext context) {
    var command = Injection.Container().resolve<TaskListModel>().commandLoad;

    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      drawer: AppDrawer(),
      body: StreamBuilder<CommandResult<List<Task>>>(
        stream: command.results,
        builder: (BuildContext context, AsyncSnapshot<CommandResult<List<Task>>> snapshot) {
          final result = snapshot.data;
          if (result == null || result.isExecuting) {
            return _buildLoader(context);
          }

          if (result.hasError) {
            return _buildError(context, result.error);
          }

          return _buildList(context, result.data);
        }
      ),
      floatingActionButton: StreamBuilder<CommandResult<List<Task>>>(
        stream: command.results,
        builder: (BuildContext context, AsyncSnapshot<CommandResult<List<Task>>> snapshot) {
          bool hideButton = !snapshot.hasData || snapshot.data.isExecuting || snapshot.data.hasError;
          if (hideButton) {
            return Container();
          }

          return FloatingActionButton(
            onPressed: () => _addNewTask(context),
            tooltip: 'Create new task',
            child: Icon(Icons.add),
          );
        }
      ),
    );
  }

  Widget _buildLoader(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError(BuildContext context, String error) {
    return Padding(
      padding: new EdgeInsets.all(25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(error),
          SizedBox(height: 30),
          RaisedButton(
            onPressed: _refreshTaskList,
            child: Text('Try Again', style: TextStyle(fontSize: 20)),
          )
        ],
      )
    );
  }

  Widget _buildList(BuildContext context, List<Task> data) {
    if (data.isEmpty) {
      return Center(
        child: Text("The list is empty"),
      );
    }

    return RefreshIndicator(
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) => _buildListRow(context, data[index]),
        physics: AlwaysScrollableScrollPhysics(),
      ),
      onRefresh: _refreshTaskList,
    );
  }

  Widget _buildListRow(BuildContext context, Task task) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.20,
      child: _buildListRowContent(context, task),
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        onDismissed: (actionType) {
          _removeTask(context, task);
        },
      ),
      key: Key(task.id.toString()),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: Colors.black45,
          icon: Icons.edit,
          onTap: () => _openTaskEditor(context, task),
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _removeTask(context, task),
        ),
      ],
    );
  }

  Widget _buildListRowContent(BuildContext context, Task task) {
    const colorByPriority = {
      Priority.Low: Colors.grey,
      Priority.Medium: Colors.green,
      Priority.High: Colors.red
    };

    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                _drawCircle(color: colorByPriority[task.priority]),
                Text(DateFormat.yMMMd().format(task.expirationDate)),
              ],
            ),
            Container(
                height: 50,
                child: VerticalDivider(color: Colors.black45, thickness: 1.0,)
            ),
            Column(
              children: <Widget>[
                Text(task.name),
                Text(task.description)
              ],
            )
          ],
        ),
      ),
      onTap: () => _openTaskEditor(context, task),
    );
  }

  Widget _drawCircle({ width = 20.0, height = 20.0, color }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Future<void> _refreshTaskList() {
    Injection.Container().resolve<TaskListModel>().commandLoad();
  }

  void _addNewTask(BuildContext context) {
    var now = DateTime.now();

    Navigator.pushNamed(
      context,
      TaskView.routeName,
      arguments: TaskViewSettings(
        task: Task(
          name: '',
          description: '',
          creationDate: now,
          expirationDate: now.add(Duration(days: 7)),
          priority: Priority.Low
        ),
        update: false,
      )
    );
  }

  void _openTaskEditor(BuildContext context, Task task) {
    Navigator.pushNamed(
      context,
      TaskView.routeName,
      arguments: TaskViewSettings(
        task: task,
        update: true,
      )
    );
  }

  void _removeTask(BuildContext context, Task task) {
    Injection.Container().resolve<TaskListModel>().commandRemove(task);
  }
}
