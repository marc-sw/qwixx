import 'dart:convert';
import 'dart:typed_data';

import 'package:nsd/nsd.dart';
import 'package:qwixx/domain/user/user.dart';

const _serviceType = '_qwixx._tcp';
const _utf8Encoder = Utf8Encoder();

class GameDiscoveryService {
  Future<Registration> publishGame(
    String host,
    int port,
    User publisher,
  ) async {
    final service = Service(
      name: publisher.uuid,
      type: _serviceType,
      port: port,
      txt: _createTxt(publisher.name, DateTime.now()),
    );

    return await register(service);
  }

  Future<void> unpublishGame(Registration registration) async {
    await unregister(registration);
  }

  Future<Discovery> startGameDiscovery() async {
    return await startDiscovery(_serviceType);
  }

  Future<void> stopGameDiscovery(Discovery discovery) async {
    return await stopDiscovery(discovery);
  }
}

Map<String, Uint8List?> _createTxt(String name, DateTime createdAt) {
  return {
    'name': _utf8Encoder.convert(name),
    'createdAt': _utf8Encoder.convert(createdAt.toString()),
  };
}
