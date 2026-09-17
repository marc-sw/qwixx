import 'dart:io';

import 'package:qwixx/data/service/game_server/mapper.dart';
import 'package:qwixx/domain/command/gateway_command.dart';

class ClientCallbacks {
  void Function(int?, String?) onDisconnected;
  void Function(GatewayMessage message) onMessage;

  new(this.onDisconnected, this.onMessage);
}

class GameClient {
  final WebSocket _webSocket;
  final MessageMapper _messageMapper;
  final ClientCallbacks _callbacks;

  const new(this._webSocket, this._messageMapper, this._callbacks);

  ClientCallbacks get callbacks => _callbacks;

  void sendMessage(GatewayMessage message) {
    _webSocket.add(_messageMapper.messageToJson(message));
  }

  void dispose() async {
    await _webSocket.close(WebSocketStatus.goingAway, 'client left');
  }
}
