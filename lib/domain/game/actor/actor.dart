import 'package:flutter/foundation.dart';
import 'package:qwixx/domain/command/gateway_command.dart';
import 'package:qwixx/domain/game/game.dart';
import 'package:qwixx/domain/gateway/gateway_controller.dart';

abstract class GameActor {
  final RollDiceCommand rollDiceCommand;
  final SkipTurnCommand skipTurnCommand;
  final String playerId;
  final GatewayController _gateway;
  final ValueNotifier<GameState> _gameStateNotifier;

  GameActor(this.playerId, this._gateway, this._gameStateNotifier)
    : rollDiceCommand = RollDiceCommand(playerId),
      skipTurnCommand = SkipTurnCommand(playerId) {
    _gameStateNotifier.addListener(onChange);
    onChange();
  }

  void onChange() {
    onGameStateChanged(_gameStateNotifier.value);
  }

  void onGameStateChanged(GameState gameState);
  void Function(GatewayMessage) get dispatch => _gateway.dispatch;

  void dispose() {
    _gameStateNotifier.removeListener(onChange);
  }
}
