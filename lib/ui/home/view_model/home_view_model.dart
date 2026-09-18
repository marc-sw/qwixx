import 'package:flutter/foundation.dart';
import 'package:qwixx/data/repository/game_discovery/game_publish_repository.dart';
import 'package:qwixx/data/repository/session/session_repository.dart';
import 'package:qwixx/data/service/game_server/game_server_service.dart';
import 'package:qwixx/domain/gateway/gateway_controller.dart';
import 'package:qwixx/domain/gateway/server_gateway_controller.dart';
import 'package:qwixx/domain/lobby/use_case/lobby_usecases.dart';
import 'package:qwixx/domain/user/user.dart';
import 'package:qwixx/main.dart';

class HomeViewModel {
  final GameServerService _gameServerService;
  final GamePublishRepository _gamePublishRepository;
  final SessionRepository _sessionRepository;

  new(
    this._sessionRepository,
    this._gameServerService,
    this._gamePublishRepository,
  );

  ValueListenable<String?> get nameNotifier =>
      _sessionRepository.nameListenable;
  String? get name => _sessionRepository.name;
  SessionRepository get session => _sessionRepository;

  VoidCallback get onSoloLobbyTap => () {
    final user = User(uuid.v4(), _sessionRepository.name!);
    final lobby = LobbyUsecases.instance.createLobby(user);
    _sessionRepository.gatewayController = GatewayController(user, lobby);
  };

  VoidCallback get onMultiLobbyTap => () async {
    final user = User(uuid.v4(), _sessionRepository.name!);
    final lobby = LobbyUsecases.instance.createLobby(user);
    final gameServer = await _gameServerService.createGameServer();
    _sessionRepository.gatewayController = ServerGatewayController(
      user,
      lobby,
      gameServer,
      _gamePublishRepository,
    );
  };
}
