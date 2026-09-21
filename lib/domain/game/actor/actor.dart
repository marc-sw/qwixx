import 'package:flutter/foundation.dart';
import 'package:qwixx/domain/command/gateway_command.dart';
import 'package:qwixx/domain/game/game.dart';
import 'package:qwixx/domain/gateway/gateway_controller.dart';

List<List<MarkNumberCommand>> _initMarkNumberCommands(String playerId) {
  return List.generate(4, (i) {
    return List.generate(11, (j) {
      final color = GameColor.byIndex(i);
      final number = NumberOrder.byColor(color).numberAt(j);
      return MarkNumberCommand(playerId, Tile(color, number));
    });
  });
}

abstract class GameActor {
  final RollDiceCommand rollDiceCommand;
  final SkipTurnCommand skipTurnCommand;
  final List<List<MarkNumberCommand>> markNumberCommands;
  final String playerId;
  final GatewayController _gateway;
  final ValueNotifier<GameState> _gameStateNotifier;

  GameActor(this.playerId, this._gateway, this._gameStateNotifier)
    : rollDiceCommand = RollDiceCommand(playerId),
      skipTurnCommand = SkipTurnCommand(playerId),
      markNumberCommands = _initMarkNumberCommands(playerId) {
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
