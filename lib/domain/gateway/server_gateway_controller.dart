import 'package:qwixx/data/repository/game_discovery/game_publish_repository.dart';
import 'package:qwixx/data/service/game_server/model.dart';
import 'package:qwixx/domain/command/gateway_command.dart';
import 'package:qwixx/domain/gateway/gateway_controller.dart';
import 'package:qwixx/domain/lobby/player.dart';

class ServerGatewayController extends GatewayController {
  final GameServer _gameServer;
  final GamePublishRepository _gamePublish;

  new(super.user, super.lobby, this._gameServer, this._gamePublish) {
    lobbyListenable.addListener(_onLobbyChanged);
    gameStateNotifierNotifier.addListener(_onGameStateNotifierChanged);
    _gameServer.callbacks.onConntected = (newUser) {
      dispatch(JoinCommand(newUser.uuid, newUser.name, PlayerKind.client));
    };
    _gameServer.callbacks.onDisconnected = (newUser) {
      dispatch(LeaveCommand(newUser.uuid));
    };
    _gameServer.callbacks.onMessage = (message) {
      dispatch(message);
    };
    _gamePublish.publishGame(_gameServer.host, _gameServer.port, user);
  }

  @override
  void dispatch(GatewayMessage message) {
    String? kickUuid;
    if (message is KickCommand && message.isLegal(lobby)) {
      kickUuid = message.targetId;
    }
    super.dispatch(message);
    if (kickUuid != null) {
      _gameServer.kick(kickUuid);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _gameServer.dispose();
    _gamePublish.unpublishGame();
  }

  void _onLobbyChanged() {
    _gameServer.broadcast(LobbyStateEvent(lobby));
  }

  void _onGameStateNotifierChanged() {
    final notifier = gameStateNotifier;
    if (notifier != null) {
      notifier.addListener(_onGameStateChanged);
      _onGameStateChanged();
    }
  }

  void _onGameStateChanged() {
    final gameState = gameStateNotifier!.value;
    _gameServer.broadcast(GameStateEvent(gameState));
  }
}
