import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart' as Injection;

import 'package:tech_demo_app/app_drawer.dart';
import 'package:tech_demo_app/data/task_repository.dart';
import 'package:tech_demo_app/domain/task_list_model.dart';
import 'package:tech_demo_app/view/dashboard_view.dart';

void main() {
  setupDependencies();
  runApp(App());
}

void setupDependencies() {
  Injection.Container container = Injection.Container();
  container.registerSingleton<TaskRepository, TaskRepositoryImpl>(
      (c) => TaskRepositoryImpl());
  container.registerSingleton<TaskListModel, TaskListModelImpl>(
      (c) => TaskListModelImpl());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tech Demo app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DashboardView(),
      routes: {
        '/dashboard': (context) => DashboardView(),
        '/task': (context) => _makeNotImplementedPage('Task'),
        '/settings': (context) => _makeNotImplementedPage('Settings'),
      },
    );
  }
}

Widget _makeNotImplementedPage(String title) {
  return Scaffold(
    appBar: AppBar(
      title: Text(title),
    ),
    drawer: AppDrawer(),
    body: Center(child:
      Text('$title screen is not implemented')
    ),
  );
}
