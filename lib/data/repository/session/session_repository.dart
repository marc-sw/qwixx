import 'package:flutter/foundation.dart';
import 'package:qwixx/data/service/local_storage/local_data_service.dart';
import 'package:qwixx/domain/gateway/gateway_controller.dart';

class SessionRepository {
  final LocalDataService _localDataService;
  final ValueNotifier<String?> _nameNotifier;
  final ValueNotifier<GatewayController?> _gatewayController;

  new(this._localDataService)
    : _nameNotifier = ValueNotifier(null),
      _gatewayController = ValueNotifier(null) {
    _loadUserFromDisk();
  }

  ValueListenable<String?> get nameListenable => _nameNotifier;
  ValueListenable<GatewayController?> get gatewayControllerNotifier =>
      _gatewayController;
  String? get name => _nameNotifier.value;
  GatewayController? get gatewayController => _gatewayController.value;

  set name(String? value) {
    if (value == name) {
      return;
    }
    _localDataService.saveName(value);
    _nameNotifier.value = value;
  }

  set gatewayController(GatewayController? value) {
    if (gatewayController != null) {
      gatewayController!.dispose();
    }
    _gatewayController.value = value;
  }

  void _loadUserFromDisk() async {
    final result = await _localDataService.getUsername();
    _nameNotifier.value = result.getOrNull();
  }

  void dispose() {
    _gatewayController.value?.dispose();
  }
}
