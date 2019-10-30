import 'package:flutter/material.dart';

import 'app_drawer.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tech Demo app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/dashboard',
      routes: {
        '/': (context) => _makeNotImplementedPage('Default'),
        '/dashboard': (context) => _makeNotImplementedPage('Dashboard'),
        '/task': (context) => _makeNotImplementedPage('Task'),
        '/settings': (context) => _makeNotImplementedPage('Settings'),
      },
    );
  }
}

Widget _makeNotImplementedPage(String title) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Dashboard"),
    ),
    drawer: AppDrawer(),
    body: Center(child:
      Text('$title screen is not implemented')
    ),
  );
}
