import 'dart:io';

import 'package:qwixx/data/service/game_client/model.dart';
import 'package:qwixx/data/service/game_server/mapper.dart';
import 'package:qwixx/domain/user/user.dart';

class GameClientService {
  Future<GameClient> createGameClient(
    String hostAddress,
    int hostPort,
    User asUser,
  ) async {
    final uri = Uri(
      scheme: 'ws',
      host: hostAddress,
      port: hostPort,
      path: '/ws',
      queryParameters: {'uuid': asUser.uuid, 'name': asUser.name},
    );

    final url = uri.toString();
    final webSocket = await WebSocket.connect(url);
    final mapper = MessageMapper.instance;
    final callbacks = ClientCallbacks((_, _) {}, (_) {});
    webSocket.listen(
      (data) {
        final message = mapper.jsonToMessage(data);
        callbacks.onMessage(message);
      },
      onDone: () =>
          callbacks.onDisconnected(webSocket.closeCode, webSocket.closeReason),
      onError: print,
      cancelOnError: true,
    );
    return GameClient(webSocket, mapper, callbacks);
  }
}
