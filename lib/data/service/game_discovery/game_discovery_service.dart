import 'dart:convert';
import 'dart:typed_data';

import 'package:nsd/nsd.dart';
import 'package:qwixx/domain/user/user.dart';
import 'package:result_dart/result_dart.dart';

const _serviceType = '_qwixx._tcp';
const _utf8Encoder = Utf8Encoder();

class GameDiscoveryService {
  Future<Result<Registration>> publishGame(
    String host,
    int port,
    User publisher,
  ) async {
    try {
      final service = Service(
        name: publisher.uuid,
        type: _serviceType,
        port: port,
        txt: _createTxt(publisher.name, DateTime.now()),
      );

      final discovery = await register(service);
      return discovery.toSuccess();
    } on Exception catch (e) {
      return e.toFailure();
    }
  }

  Future<Result<Unit>> unpublishGame(Registration registration) async {
    try {
      await unregister(registration);
      return Success.unit();
    } on Exception catch (e) {
      return e.toFailure();
    }
  }

  Future<Result<Discovery>> startGameDiscovery() async {
    try {
      return (await startDiscovery(_serviceType)).toSuccess();
    } on Exception catch (e) {
      return e.toFailure();
    }
  }

  Future<Result<Unit>> stopGameDiscovery(Discovery discovery) async {
    try {
      await stopDiscovery(discovery);
      return Success.unit();
    } on Exception catch (e) {
      return e.toFailure();
    }
  }
}

Map<String, Uint8List?> _createTxt(String name, DateTime createdAt) {
  return {
    'name': _utf8Encoder.convert(name),
    'createdAt': _utf8Encoder.convert(createdAt.toString()),
  };
}
