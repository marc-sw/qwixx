part of '../gateway_command.dart';

class MarkNumberCommand extends GameCommand {
  final GameColor color;
  final Number number;

  new(super.playerId, this.color, this.number);

  @override
  GameState execute(GameState gameState) {
    int cardIndex = gameState.cardIndexOf(issuerId);
    var turn = gameState.turn;
    var card = gameState.cards[cardIndex];
    var rolls = gameState.diceRolls;
    card = card.markNumber(color, number);

    int rowIndex = NumberOrder.byColor(color).indexOf(number);

    if (rowIndex == GameConfig.lastRowIndex) {
      rolls = rolls.removeColoredDice(color);
    }

    if (canMarkWithColoredDice(gameState)) {
      turn = gameState.turn.setColoredActionResult(ActionResult.marked);
    } else if (canMarkWithWhiteDice(gameState)) {
      turn = gameState.turn.setWhiteActionResult(
        cardIndex,
        ActionResult.marked,
      );
    } else {
      throw UnimplementedError(
        'executing MarkNumberCommand, caught illegal state where executing is running with illegal state',
      );
    }

    if (turn.isDone()) {
      turn = turn.nextTurn();
    }

    return GameState(
      cards: gameState.setCard(cardIndex, card),
      diceRolls: rolls,
      turn: turn,
    );
  }

  @override
  bool isLegal(GameState gameState) {
    if (gameState.phase != GamePhase.markNumber) {
      return false;
    }
    if (canMarkWithColoredDice(gameState)) {
      return true;
    }
    return canMarkWithWhiteDice(gameState);
  }

  bool canMarkWithColoredDice(GameState gameState) {
    int cardIndex = gameState.cardIndexOf(issuerId);
    if (cardIndex == -1) {
      return false;
    }
    if (!gameState.turn.canMarkWithColoredDice(cardIndex)) {
      return false;
    }
    if (!gameState.diceRolls.coloredTargets.contains((
      color: color,
      number: number,
    ))) {
      return false;
    }
    return gameState.cards[cardIndex].canMarkNumber(color, number);
  }

  bool canMarkWithWhiteDice(GameState gameSate) {
    int cardIndex = gameSate.cardIndexOf(issuerId);
    if (cardIndex == -1) {
      return false;
    }
    if (!gameSate.turn.canMarkWithWhiteDice(cardIndex)) {
      return false;
    }
    if (!gameSate.diceRolls.whiteTargets.contains((
      color: color,
      number: number,
    ))) {
      return false;
    }

    return gameSate.cards[cardIndex].canMarkNumber(
      color,
      gameSate.diceRolls.whiteSum,
    );
  }
}
