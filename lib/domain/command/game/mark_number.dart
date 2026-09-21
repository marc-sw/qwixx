part of '../gateway_command.dart';

@JsonSerializable(explicitToJson: true)
class MarkNumberCommand extends GameCommand {
  final Tile tile;

  new(super.issuerId, this.tile);
  factory MarkNumberCommand.fromJson(Map<String, dynamic> json) =>
      _$MarkNumberCommandFromJson(json);
  Map<String, dynamic> toJson() => _$MarkNumberCommandToJson(this);

  @override
  GameState execute(GameState gameState) {
    int cardIndex = gameState.cardIndexOf(issuerId);
    var turn = gameState.turn;
    var card = gameState.cards[cardIndex];
    var rolls = gameState.diceRolls;
    card = card.markNumber(tile.color, tile.number);

    int rowIndex = NumberOrder.byColor(tile.color).indexOf(tile.number);

    if (rowIndex == GameConfig.lastRowIndex) {
      rolls = rolls.removeColoredDice(tile.color);
    }
    if (cardIndex != gameState.turn.activeCardIndex ||
        gameState.turn.activePlayerFirstMarkedTile != null) {
      turn = gameState.turn.setActionResult(cardIndex, ActionResult.marked);
    } else {
      turn = gameState.turn.setActivePlayerFirstMark(tile);
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
    bool canMark = canMarkTile(gameState);
    return canMark;
  }

  bool canMarkTile(GameState gameState) {
    int cardIndex = gameState.cardIndexOf(issuerId);
    if (cardIndex == -1 ||
        !gameState.turn.isAwaitingAction(cardIndex) ||
        !gameState.cards[cardIndex].canMarkNumber(tile.color, tile.number)) {
      return false;
    }
    if (cardIndex != gameState.turn.activeCardIndex) {
      return gameState.diceRolls.whiteTargets.contains(tile);
    }
    final firstTile = gameState.turn.activePlayerFirstMarkedTile;
    bool isWhiteAvailable =
        firstTile == null ||
        gameState.diceRolls.coloredTargets.contains(firstTile);
    bool isColoredAvailable =
        firstTile == null ||
        gameState.diceRolls.whiteTargets.contains(firstTile);
    return isWhiteAvailable &&
            gameState.diceRolls.whiteTargets.contains(tile) ||
        isColoredAvailable && gameState.diceRolls.coloredTargets.contains(tile);
  }
}
