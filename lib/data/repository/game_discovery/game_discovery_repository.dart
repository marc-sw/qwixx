import 'dart:async';
import 'dart:convert';

import 'package:nsd/nsd.dart';
import 'package:qwixx/data/service/game_discovery/game_discovery_service.dart';
import 'package:qwixx/domain/user/user.dart';
import 'package:result_dart/result_dart.dart';

const _utf8Decoder = Utf8Decoder();

ServerInfo parseServerInfo(Service service) {
  final txt = service.txt!;

  String name = _utf8Decoder.convert(txt['name']!);

  DateTime createdAt = DateTime.parse(_utf8Decoder.convert(txt['createdAt']!));
  return ServerInfo(
    service.host!,
    service.port!,
    createdAt,
    User(service.name!, name),
  );
}

class ServerInfo {
  final String serverAddress;
  final int serverPort;
  final DateTime createdAt;
  final User host;

  const new(this.serverAddress, this.serverPort, this.createdAt, this.host);
}

class ServerInfoUpdate {
  final ServerInfo info;
  final bool added;
  const new(this.info, this.added);
}

class GameDiscoveryRepository {
  final GameDiscoveryService _service;
  StreamController<ServerInfoUpdate>? _controller;

  new(this._service);

  Future<Result<Stream<ServerInfoUpdate>>> startDiscovering() async {
    try {
      await stopDiscovering();
      final discoveryResult = await _service.startGameDiscovery();
      if (discoveryResult.isError()) {
        return discoveryResult.exceptionOrNull()!.toFailure();
      }
      final discovery = discoveryResult.getOrThrow();
      discovery.addServiceListener(_onServiceChanged);
      _controller = StreamController<ServerInfoUpdate>(
        onCancel: () async => await _service.stopGameDiscovery(discovery),
      );
      return _controller!.stream.toSuccess();
    } on Exception catch (e) {
      return e.toFailure();
    }
  }

  Future<Result<Unit>> stopDiscovering() async {
    if (_controller == null) {
      return Success.unit();
    }
    try {
      await _controller!.close();
      _controller = null;
      return Success.unit();
    } on Exception catch (e) {
      return e.toFailure();
    }
  }

  Future<Result<List<ServerInfo>>> getServerInfos(Duration duration) async {
    final List<ServerInfo> infos = [];
    try {
      await stopDiscovering();
      final discovery = await _service.startGameDiscovery().getOrThrow();
      discovery.addServiceListener((service, status) {
        final infoUpdate = parseServerInfo(service);
        if (status == ServiceStatus.found) {
          infos.add(infoUpdate);
        } else {
          final index = infos.indexWhere(
            (info) =>
                info.serverAddress == infoUpdate.serverAddress &&
                info.serverPort == infoUpdate.serverPort,
          );
          if (index != -1) {
            infos.removeAt(index);
          }
        }
      });
      await Future.delayed(duration, () async => await stopDiscovering());
      return infos.toSuccess();
    } on Exception catch (e) {
      return e.toFailure();
    }
  }

  void _onServiceChanged(Service service, ServiceStatus status) {
    final info = parseServerInfo(service);
    bool added = status == ServiceStatus.found;
    _controller?.add(ServerInfoUpdate(info, added));
  }

  void dispose() {
    stopDiscovering();
  }
}
