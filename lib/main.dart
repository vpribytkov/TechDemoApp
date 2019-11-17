import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart' as Injection;

import 'package:tech_demo_app/preferences.dart';
import 'package:tech_demo_app/data/task_repository.dart';
import 'package:tech_demo_app/domain/task_list_model.dart';
import 'package:tech_demo_app/view/dashboard_view.dart';
import 'package:tech_demo_app/view/preferences_view.dart';
import 'package:tech_demo_app/view/task_view.dart';

void main() async {
  globalPreferences = await Preferences.init();

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
      onGenerateRoute: (RouteSettings settings) {
        var routes = <String, WidgetBuilder>{
          DashboardView.routeName: (context) => DashboardView(),
          TaskView.routeName: (context) => TaskView(settings.arguments),
          PreferencesView.routeName: (context) => PreferencesView(),
        };
        return MaterialPageRoute(builder: (context) => routes[settings.name](context));
      },
    );
  }
}
