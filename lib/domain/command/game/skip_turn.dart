part of '../gateway_command.dart';

class SkipTurnCommand extends GameCommand {
  new(super.issuerCardIndex);

  @override
  GameState execute(GameState gameState) {
    int cardIndex = gameState.cardIndexOf(issuerId);
    var turn = gameState.turn.skipAction(cardIndex);
    GameCards? cards;
    if (turn.isFailThrow(cardIndex)) {
      cards = gameState.increaseMisses(cardIndex);
    }
    if (turn.isDone()) {
      turn = turn.nextTurn();
    }
    return gameState.copyWith(newCards: cards, newTurn: turn);
  }

  @override
  bool isLegal(GameState gameState) {
    if (gameState.phase != GamePhase.markNumber) {
      return false;
    }
    int cardIndex = gameState.cardIndexOf(issuerId);
    if (cardIndex == -1) {
      return false;
    }
    return gameState.turn.isAwaitingAction(cardIndex);
  }
}
