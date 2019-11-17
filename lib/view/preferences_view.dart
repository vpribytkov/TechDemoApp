import 'package:flutter/material.dart';

import 'package:tech_demo_app/preferences.dart';

class PreferencesView extends StatefulWidget {
  static const routeName = "preferences";

  @override
  State<StatefulWidget> createState() => _PreferencesState();
}

class _PreferencesState extends State<PreferencesView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferences'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SwitchListTile(
            title: Text('Show Expiration Date'),
            subtitle: Text('Display Expiration Date property on task screen'),
            value: globalPreferences.getShowExpirationDate(),
            onChanged: (bool value) { _setShowExpirationDate(value); },
            secondary: const Icon(Icons.date_range),
          ),
          SwitchListTile(
            title: Text('Show Priority'),
            subtitle: Text('Display Priority property on task screen'),
            value: globalPreferences.getShowPriority(),
            onChanged: (bool value) { _setShowPriority(value); },
            secondary: const Icon(Icons.low_priority),
          )
        ]
      )
    );
  }

  _setShowExpirationDate(value) {
    setState(() {
      globalPreferences.setShowExpirationDate(value);
    });
  }

  _setShowPriority(value) {
    setState(() {
      globalPreferences.setShowPriority(value);
    });
  }
}