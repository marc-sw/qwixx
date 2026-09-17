part of '../gateway_command.dart';

class GameStateEvent extends EventMessage {
  final GameState gameState;

  const new(this.gameState);
}
