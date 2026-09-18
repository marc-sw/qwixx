import 'dart:async';
import 'dart:convert';

import 'package:nsd/nsd.dart';
import 'package:qwixx/data/service/game_discovery/game_discovery_service.dart';
import 'package:qwixx/domain/user/user.dart';

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

  Future<Stream<ServerInfoUpdate>> startDiscovering() async {
    await stopDiscovering();
    final discovery = await _service.startGameDiscovery();
    discovery.addServiceListener(_onServiceChanged);
    _controller = StreamController<ServerInfoUpdate>(
      onCancel: () async => await _service.stopGameDiscovery(discovery),
    );
    return _controller!.stream;
  }

  Future<void> stopDiscovering() async {
    if (_controller != null) {
      await _controller!.close();
      _controller = null;
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
