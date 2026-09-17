import 'package:flutter/foundation.dart';
import 'package:qwixx/data/repository/session/session_repository.dart';
import 'package:qwixx/data/service/game_server/game_server_service.dart';
import 'package:qwixx/domain/gateway/gateway_controller.dart';
import 'package:qwixx/domain/gateway/server_gateway_controller.dart';
import 'package:qwixx/domain/lobby/use_case/lobby_usecases.dart';
import 'package:qwixx/domain/user/user.dart';

class HomeViewModel {
  final GameServerService _gameServerService;
  final SessionRepository _sessionRepository;

  new(this._sessionRepository, this._gameServerService);

  ValueListenable<User?> get userNotifier => _sessionRepository.userListenable;
  User? get user => _sessionRepository.user;

  VoidCallback get onSoloLobbyTap => () {
    final user = _sessionRepository.user!;
    final lobby = LobbyUsecases.instance.createLobby(user);
    _sessionRepository.gatewayController = GatewayController(user, lobby);
  };

  VoidCallback get onMultiLobbyTap => () async {
    final user = _sessionRepository.user!;
    final lobby = LobbyUsecases.instance.createLobby(_sessionRepository.user!);
    final gameServer = await _gameServerService.createGameServer();
    _sessionRepository.gatewayController = ServerGatewayController(
      user,
      lobby,
      gameServer,
    );
  };
}
