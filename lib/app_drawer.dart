import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Text('Side Menu Info'),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.dashboard),
                  title: Text("Dashboard"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/dashboard');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.add_circle_outline),
                  title: Text("Create Task"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/task');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text("Settings"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
              ],
            )
          ],
        )
    );
  }
}