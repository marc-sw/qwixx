import 'package:qwixx/data/repository/session/session_repository.dart';
import 'package:qwixx/domain/user/user.dart';
import 'package:qwixx/main.dart';

class SettingsViewModel {
  //final UserSessionRepository _userSessionRepository;
  final SessionRepository _sessionRepository;
  const new(this._sessionRepository);

  void onUsernameSubmit(String username) {
    username = username.trim();
    if (username == _sessionRepository.user?.name) {
      return;
    }
    if (username.isEmpty) {
      _sessionRepository.user = null;
      return;
    }
    String userId = _userid ?? uuid.v4();
    _sessionRepository.user = User(userId, username);
  }

  void resetSettings() {
    _sessionRepository.user = null;
  }

  String? get username => _sessionRepository.user?.name;
  String? get _userid => _sessionRepository.user?.uuid;
}
