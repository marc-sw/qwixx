part of '../gateway_command.dart';

class RollDiceCommand extends GameCommand {
  new(super.playerId);

  @override
  GameState execute(GameState gameState) {
    return gameState.copyWith(
      newDiceRolls: gameState.diceRolls.roll(),
      newTurn: gameState.turn.setRolled(true),
    );
  }

  @override
  bool isLegal(GameState gameState) {
    return gameState.phase == GamePhase.rollDice &&
        gameState.activeCard.player.uuid == issuerId;
  }
}
