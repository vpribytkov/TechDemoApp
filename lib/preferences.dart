import 'package:shared_preferences/shared_preferences.dart';

Preferences globalPreferences;

class Preferences {
  static Future<Preferences> init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return Preferences(preferences);
  }

  Preferences(this._preferences);

  bool getShowExpirationDate() => _getBool(_showExpirationDateKey, true);

  void setShowExpirationDate(value) {
    _preferences.setBool(_showExpirationDateKey, value);
  }

  bool getShowPriority() => _getBool(_showPriorityKey, true);

  void setShowPriority(value) {
    _setBool(_showPriorityKey, value);
  }

  bool _getBool(key, defaultValue) {
    if (!_preferences.containsKey(key)) {
      return defaultValue;
    }

    return _preferences.getBool(key);
  }

  void _setBool(key, value) {
    _preferences.setBool(key, value);
  }

  static const _showExpirationDateKey = 'showExpirationDate';
  static const _showPriorityKey = 'showPriority';

  SharedPreferences _preferences;
}