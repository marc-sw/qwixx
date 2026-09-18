import 'dart:io';

import 'package:qwixx/data/service/game_server/mapper.dart';
import 'package:qwixx/data/service/game_server/model.dart';
import 'package:qwixx/domain/user/user.dart';

class GameServerService {
  Future<GameServer> createGameServer() async {
    final httpServer = await HttpServer.bind(InternetAddress.anyIPv4, 0);
    final Map<String, WebSocket> webSockets = {};
    final MessageMapper mapper = MessageMapper.instance;
    final ServerCallbacks callbacks = ServerCallbacks((_) {}, (_) {}, (_) {});
    final gameServer = GameServer(httpServer, webSockets, mapper, callbacks);
    httpServer.listen((request) async {
      if (request.uri.path != '/ws') {
        request.response
          ..statusCode = HttpStatus.notFound
          ..close();
        return;
      }

      final name = request.uri.queryParameters['name'];
      final uuid = request.uri.queryParameters['uuid'];

      if (name == null || uuid == null || name.isEmpty || uuid.isEmpty) {
        request.response
          ..statusCode = HttpStatus.badRequest
          ..write('name or uuid missing')
          ..close;
        return;
      }
      final user = User(uuid, name);

      final webSocket = await WebSocketTransformer.upgrade(request);

      webSockets[uuid] = webSocket;
      callbacks.onConntected(user);

      webSocket.listen(
        (data) {
          final message = mapper.jsonToMessage(data);
          callbacks.onMessage(message);
        },
        onDone: () {
          webSockets.remove(user.uuid);
          callbacks.onDisconnected(user);
        },
        onError: print,
        cancelOnError: true,
      );
    });
    return gameServer;
  }
}
