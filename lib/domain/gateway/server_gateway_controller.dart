import 'package:qwixx/data/service/game_server/model.dart';
import 'package:qwixx/domain/command/gateway_command.dart';
import 'package:qwixx/domain/gateway/gateway_controller.dart';
import 'package:qwixx/domain/lobby/player.dart';

class ServerGatewayController extends GatewayController {
  final GameServer _gameServer;

  new(super.user, super.lobby, this._gameServer) {
    lobbyListenable.addListener(_onLobbyChanged);
    gameStateNotifierNotifier.addListener(_onGameStateNotifierChanged);
    _gameServer.callbacks.onConntected = (user) {
      dispatch(JoinCommand(user.uuid, user.name, PlayerKind.client));
    };
    _gameServer.callbacks.onDisconnected = (user) {
      dispatch(LeaveCommand(user.uuid));
    };
    _gameServer.callbacks.onMessage = (message) {
      dispatch(message);
    };
  }

  @override
  void dispatch(GatewayMessage message) {
    String? kickUuid;
    if (message is KickCommand && message.isLegal(lobby)) {
      kickUuid = message.targetUUID;
    }
    super.dispatch(message);

    if (kickUuid != null) {
      _gameServer.kick(kickUuid);
    }
  }

  void _onLobbyChanged() {
    _gameServer.broadcast(LobbyStateEvent(lobby));
  }

  void _onGameStateNotifierChanged() {
    final notifier = gameStateNotifier;
    if (notifier != null) {
      notifier.addListener(_onGameStateChanged);
    }
  }

  void _onGameStateChanged() {
    final gameState = gameStateNotifier!.value;
    _gameServer.broadcast(GameStateEvent(gameState));
  }
}
