import 'package:qwixx/domain/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _uuidKey = 'qwixx_user_uuid';
const _nameKey = 'qwixx_user_name';

class LocalDataService {
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    final uuid = prefs.getString(_uuidKey);
    final name = prefs.getString(_nameKey);

    if (uuid == null || name == null) {
      return null;
    }

    return User(uuid, name);
  }

  Future<void> saveUser(User? user) async {
    final prefs = await SharedPreferences.getInstance();

    if (user == null) {
      await Future.wait([prefs.remove(_uuidKey), prefs.remove(_nameKey)]);
    } else {
      await Future.wait([
        prefs.setString(_uuidKey, user.uuid),
        prefs.setString(_nameKey, user.name),
      ]);
    }
  }
}
