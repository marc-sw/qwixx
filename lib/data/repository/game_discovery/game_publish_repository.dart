import 'package:nsd/nsd.dart';
import 'package:qwixx/data/service/game_discovery/game_discovery_service.dart';
import 'package:qwixx/domain/user/user.dart';
import 'package:result_dart/result_dart.dart';

class GamePublishRepository {
  final GameDiscoveryService _service;
  Registration? _registration;

  new(this._service);

  Future<Result<Unit>> publishGame(
    String host,
    int port,
    User publisher,
  ) async {
    final registrationResult = await _service.publishGame(
      host,
      port,
      publisher,
    );
    if (registrationResult.isSuccess()) {
      _registration = registrationResult.getOrThrow();
    }
    return registrationResult.map((r) => unit);
  }

  Future<Result<Unit>> unpublishGame() async {
    if (_registration == null) {
      return Success.unit();
    }
    final result = await _service.unpublishGame(_registration!);
    if (result.isSuccess()) {
      _registration = null;
    }
    return result;
  }

  void dispose() {
    unpublishGame();
  }
}
