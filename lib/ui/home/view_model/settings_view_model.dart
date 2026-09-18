import 'package:qwixx/data/repository/session/session_repository.dart';

class SettingsViewModel {
  final SessionRepository _sessionRepository;
  const new(this._sessionRepository);

  void onUsernameSubmit(String username) {
    username = username.trim();
    if (username == _sessionRepository.name) {
      return;
    }
    if (username.isEmpty) {
      _sessionRepository.name = null;
      return;
    }
    _sessionRepository.name = username;
  }

  void resetSettings() {
    _sessionRepository.name = null;
  }

  String? get username => _sessionRepository.name;
}
