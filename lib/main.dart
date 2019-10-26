import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tech Demo app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Text('App is under construction.'),
    );
  }
}
