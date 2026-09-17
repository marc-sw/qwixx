import 'package:qwixx/data/repository/session/session_repository.dart';
import 'package:qwixx/domain/command/gateway_command.dart';
import 'package:qwixx/domain/game/use_case/game_state_usecases.dart';
import 'package:qwixx/domain/gateway/gateway_controller.dart';
import 'package:qwixx/domain/lobby/lobby.dart';
import 'package:qwixx/domain/lobby/player.dart';
import 'package:qwixx/domain/lobby/use_case/lobby_usecases.dart';

class LobbyViewModel {
  final SessionRepository _sessionRepository;
  final GatewayController _gatewayController;

  new(this._sessionRepository, this._gatewayController);

  SessionRepository get session => _sessionRepository;
  GatewayController get gateway => _gatewayController;
  Lobby get lobby => _gatewayController.lobby;

  void addBot() {
    Player bot = LobbyUsecases.instance.createBot(lobby);
    JoinCommand cmd = JoinCommand(bot.uuid, bot.name, bot.kind);
    _gatewayController.dispatch(cmd);
  }

  void kickPlayer(int index) {
    KickCommand cmd = KickCommand(
      _gatewayController.user.uuid,
      lobby.all[index].uuid,
    );
    _gatewayController.dispatch(cmd);
  }

  bool isHost() {
    return _gatewayController.user.uuid == lobby.host.uuid;
  }

  bool isUser(Player player) {
    return _gatewayController.user.uuid == player.uuid;
  }

  void createGame() {
    final gameState = GameStateUsecases.instance.createGameStateFromLobby(
      lobby,
    );
    final GameStateEvent event = GameStateEvent(gameState);
    _gatewayController.dispatch(event);
  }

  void deleteGateway() {
    _sessionRepository.gatewayController = null;
  }
}
