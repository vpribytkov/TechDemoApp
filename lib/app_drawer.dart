import 'package:flutter/material.dart';
import 'package:tech_demo_app/view/dashboard_view.dart';
import 'package:tech_demo_app/view/preferences_view.dart';

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
                    Navigator.pushNamed(context, DashboardView.routeName);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text("Settings"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, PreferencesView.routeName);
                  },
                ),
              ],
            )
          ],
        )
    );
  }
}