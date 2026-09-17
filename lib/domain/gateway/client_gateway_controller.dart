import 'package:qwixx/data/repository/session/session_repository.dart';
import 'package:qwixx/data/service/game_client/model.dart';
import 'package:qwixx/domain/command/gateway_command.dart';
import 'package:qwixx/domain/gateway/gateway_controller.dart';

class ClientGatewayController extends GatewayController {
  final SessionRepository _session;
  final GameClient _gameClient;

  new(super.user, super.lobby, this._gameClient, this._session) {
    _gameClient.callbacks.onMessage = _onMessage;
    _gameClient.callbacks.onDisconnected = _onDisconnected;
  }

  void _onMessage(GatewayMessage message) {
    super.dispatch(message);
  }

  void _onDisconnected(int? code, String? reason) {
    _session.gatewayController = null;
  }

  @override
  void dispatch(GatewayMessage message) {
    _gameClient.sendMessage(message);
  }
}
