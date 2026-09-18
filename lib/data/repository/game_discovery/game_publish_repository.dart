import 'package:nsd/nsd.dart';
import 'package:qwixx/data/service/game_discovery/game_discovery_service.dart';
import 'package:qwixx/domain/user/user.dart';

class GamePublishRepository {
  final GameDiscoveryService _service;
  Registration? _registration;

  new(this._service);

  void publishGame(String host, int port, User publisher) async {
    _registration = await _service.publishGame(host, port, publisher);
  }

  void unpublishGame() async {
    if (_registration != null) {
      await _service.unpublishGame(_registration!);
      _registration = null;
    }
  }

  void dispose() {
    unpublishGame();
  }
}
