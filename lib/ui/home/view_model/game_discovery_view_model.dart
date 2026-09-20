import 'package:command_it/command_it.dart';
import 'package:flutter/foundation.dart';
import 'package:qwixx/data/repository/game_discovery/game_discovery_repository.dart';
import 'package:qwixx/data/repository/session/session_repository.dart';
import 'package:qwixx/data/service/game_client/game_client_service.dart';
import 'package:qwixx/domain/gateway/client_gateway_controller.dart';
import 'package:qwixx/domain/lobby/lobby.dart';
import 'package:qwixx/domain/lobby/player.dart';
import 'package:qwixx/domain/user/user.dart';
import 'package:qwixx/main.dart';
import 'package:result_dart/result_dart.dart';

class GameDiscoveryViewModel {
  final GameDiscoveryRepository _gameDiscovery;
  final GameClientService _gameClientService;
  final SessionRepository _session;
  final ValueNotifier<List<ServerInfo>> _serverInfosNotifier;
  void Function(int)? afterAdd;
  void Function(int, ServerInfo)? beforeRemove;

  late final joinGameCommand = Command.createAsyncNoResult(_joinGame);

  late final searchGamesCommand =
      Command.createAsyncNoParamNoResultWithProgress(_searchGames);

  new(this._gameDiscovery, this._session, this._gameClientService)
    : _serverInfosNotifier = ValueNotifier([]) {
    searchGamesCommand.isCanceled.addListener(() {
      if (searchGamesCommand.isCanceled.value) {
        _stopSearching();
      }
    });
  }

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

  Future<void> _joinGame(ServerInfo info) async {
    final user = User(uuid.v4(), _session.name!);
    final lobby = Lobby([
      Player(info.host.uuid, info.host.name, PlayerKind.host),
    ]);
    final clientResult = await _gameClientService.createGameClient(
      info.serverAddress,
      info.serverPort,
      user,
    );
    _session.gatewayController = ClientGatewayController(
      user,
      lobby,
      clientResult.getOrThrow(),
      _session,
    );
  }

  Future<void> _searchGames(ProgressHandle handle) async {
    for (var i = _serverInfosNotifier.value.length - 1; i >= 0; i--) {
      _remove(i);
    }
    final stream = await _gameDiscovery.startDiscovering().getOrThrow();
    await for (final data in stream) {
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
    }
  }

  void _stopSearching() async {
    await _gameDiscovery.stopDiscovering();
    print('stopped searching');
  }
}
