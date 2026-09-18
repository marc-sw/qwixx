import 'package:flutter/foundation.dart';
import 'package:qwixx/data/repository/game_discovery/game_discovery_repository.dart';
import 'package:qwixx/data/repository/session/session_repository.dart';
import 'package:qwixx/data/service/game_client/game_client_service.dart';
import 'package:qwixx/domain/gateway/client_gateway_controller.dart';
import 'package:qwixx/domain/lobby/lobby.dart';
import 'package:qwixx/domain/lobby/player.dart';
import 'package:qwixx/domain/user/user.dart';
import 'package:qwixx/main.dart';

class GameDiscoveryViewModel {
  final GameDiscoveryRepository _gameDiscovery;
  final GameClientService _gameClientService;
  final SessionRepository _session;
  final ValueNotifier<List<ServerInfo>> _serverInfosNotifier;
  final ValueNotifier<bool> _discoveringNotifier;
  void Function(int)? afterAdd;
  void Function(int, ServerInfo)? beforeRemove;

  new(this._gameDiscovery, this._session, this._gameClientService)
    : _discoveringNotifier = ValueNotifier(false),
      _serverInfosNotifier = ValueNotifier([]);

  ValueListenable<bool> get discoveringListenable => _discoveringNotifier;
  ValueListenable<List<ServerInfo>> get serverInfosListenable =>
      _serverInfosNotifier;

  void _add(ServerInfo info) {
    final newList = List.of(_serverInfosNotifier.value);
    newList.add(info);
    _serverInfosNotifier.value = newList;
    afterAdd?.call(newList.length - 1);
  }

  void _remove(int index) {
    final newList = List.of(_serverInfosNotifier.value);
    final info = newList.removeAt(index);
    beforeRemove?.call(index, info);
    _serverInfosNotifier.value = newList;
  }

  void start() async {
    for (var i = _serverInfosNotifier.value.length - 1; i >= 0; i--) {
      _remove(i);
    }
    _discoveringNotifier.value = true;
    final stream = await _gameDiscovery.startDiscovering();
    stream.listen(
      (data) {
        if (data.added) {
          _add(data.info);
        } else {
          int index = _serverInfosNotifier.value.indexWhere(
            (info) => info.host.uuid == data.info.host.uuid,
          );
          if (index == -1) {
            return;
          }
          //animate
          _remove(index);
        }
      },
      onDone: () {
        _discoveringNotifier.value = false;
      },
    );
  }

  void stop() async {
    await _gameDiscovery.stopDiscovering();
  }

  void join(ServerInfo info) async {
    final user = User(uuid.v4(), _session.name!);
    final lobby = Lobby([
      Player(info.host.uuid, info.host.name, PlayerKind.host),
    ]);
    final client = await _gameClientService.createGameClient(
      info.serverAddress,
      info.serverPort,
      user,
    );
    _session.gatewayController = ClientGatewayController(
      user,
      lobby,
      client,
      _session,
    );
  }
}
