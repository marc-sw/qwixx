import 'package:flutter/foundation.dart';
import 'package:qwixx/data/service/local_storage/local_data_service.dart';
import 'package:qwixx/domain/gateway/gateway_controller.dart';
import 'package:qwixx/domain/user/user.dart';

class SessionRepository {
  final LocalDataService _localDataService;
  final ValueNotifier<User?> _userNotifier;
  final ValueNotifier<GatewayController?> _gatewayController;

  new(this._localDataService)
    : _userNotifier = ValueNotifier(null),
      _gatewayController = ValueNotifier(null) {
    _loadUserFromDisk();
  }

  ValueListenable<User?> get userListenable => _userNotifier;
  ValueListenable<GatewayController?> get gatewayControllerNotifier =>
      _gatewayController;
  User? get user => _userNotifier.value;
  GatewayController? get gatewayController => _gatewayController.value;

  set user(User? value) {
    if (value == user) {
      return;
    }
    _localDataService.saveUser(value);
    _userNotifier.value = value;
  }

  set gatewayController(GatewayController? value) {
    _gatewayController.value = value;
  }

  void _loadUserFromDisk() async {
    _userNotifier.value = await _localDataService.getUser();
  }
}
