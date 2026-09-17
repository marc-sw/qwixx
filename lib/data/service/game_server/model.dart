import 'dart:io';

import 'package:qwixx/data/service/game_server/mapper.dart';
import 'package:qwixx/domain/command/gateway_command.dart';
import 'package:qwixx/domain/user/user.dart';

typedef UserHandler = void Function(User);
typedef MessageHandler = void Function(GatewayMessage);

class ServerCallbacks {
  UserHandler onConntected;
  UserHandler onDisconnected;
  MessageHandler onMessage;

  new(this.onConntected, this.onDisconnected, this.onMessage);
}

class GameServer {
  final HttpServer _httpServer;
  final Map<String, WebSocket> _connections;
  final MessageMapper _messageMapper;
  final ServerCallbacks _callbacks;

  new(
    this._httpServer,
    this._connections,
    this._messageMapper,
    this._callbacks,
  );

  ServerCallbacks get callbacks => _callbacks;

  void broadcast(GatewayMessage message) {
    final json = _messageMapper.messageToJson(message);
    for (final connection in _connections.values) {
      connection.add(json);
    }
  }

  void send(String uuid, GatewayMessage message) {
    final json = _messageMapper.messageToJson(message);
    _connections[uuid]?.add(json);
  }

  void kick(String uuid) {
    final socket = _connections.remove(uuid);
    socket?.close(WebSocketStatus.goingAway, 'kicked by host');
  }

  void dispose() async {
    for (final connection in _connections.values) {
      await connection.close(WebSocketStatus.goingAway, 'host left');
    }
    await _httpServer.close();
  }
}
