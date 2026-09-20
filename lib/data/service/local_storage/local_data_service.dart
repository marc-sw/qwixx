import 'package:result_dart/result_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _nameKey = 'qwixx_user_name';

class AppException implements Exception {
  final Reason reason;

  const new(this.reason);
}

enum Reason { usernameNotFound }

class LocalDataService {
  Future<Result<String>> getUsername() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? name = prefs.getString(_nameKey);
      if (name == null) {
        return Failure(AppException(Reason.usernameNotFound));
      }
      return Success(name);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<Unit>> saveName(String? name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (name == null) {
        await prefs.remove(_nameKey);
      } else {
        await prefs.setString(_nameKey, name);
      }
      return Success.unit();
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
