import 'package:shared_preferences/shared_preferences.dart';

const _nameKey = 'qwixx_user_name';

class LocalDataService {
  Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey);
  }

  Future<void> saveName(String? name) async {
    final prefs = await SharedPreferences.getInstance();

    if (name == null) {
      await prefs.remove(_nameKey);
    } else {
      await prefs.setString(_nameKey, name);
    }
  }
}
