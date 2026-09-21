part of 'game.dart';

@JsonSerializable(explicitToJson: true)
class GameTurn {
  final int activeCardIndex;
  final Tile? activePlayerFirstMarkedTile;
  final List<ActionResult> playerResults;
  final bool rolled;

  const GameTurn(
    this.activeCardIndex,
    this.activePlayerFirstMarkedTile,
    this.playerResults,
    this.rolled,
  );
  factory GameTurn.fromJson(Map<String, dynamic> json) =>
      _$GameTurnFromJson(json);
  Map<String, dynamic> toJson() => _$GameTurnToJson(this);

  factory GameTurn.init(int startingCardIndex, int cardCount) {
    return GameTurn(
      startingCardIndex,
      null,
      List<ActionResult>.filled(cardCount, ActionResult.awaiting),
      false,
    );
  }

  bool isAwaitingAction(int cardIndex) {
    return playerResults[cardIndex] == ActionResult.awaiting;
  }

  bool isFailThrow(int cardIndex) {
    return cardIndex == activeCardIndex &&
        activePlayerFirstMarkedTile == null &&
        playerResults[cardIndex] == ActionResult.skipped;
  }

  bool isDone() {
    return !playerResults.any((result) => result == ActionResult.awaiting);
  }

  bool didAnyAction(int cardIndex) {
    return playerResults[cardIndex] != ActionResult.awaiting ||
        activeCardIndex == cardIndex && activePlayerFirstMarkedTile != null;
  }

  bool isActiveCard(int cardIndex) {
    return activeCardIndex == cardIndex;
  }

  GameTurn skipAction(int cardIndex) {
    if (playerResults[cardIndex] != ActionResult.awaiting) {
      return this;
    }
    final results = List<ActionResult>.from(playerResults);
    results[cardIndex] = ActionResult.skipped;
    return GameTurn(
      activeCardIndex,
      activePlayerFirstMarkedTile,
      results,
      rolled,
    );
  }

  GameTurn nextTurn() {
    final int nextCardIndex = (activeCardIndex + 1) % playerResults.length;
    return GameTurn(
      nextCardIndex,
      null,
      List<ActionResult>.filled(playerResults.length, ActionResult.awaiting),
      false,
    );
  }

  GameTurn setActivePlayerFirstMark(Tile tile) {
    if (activePlayerFirstMarkedTile != null) {
      return this;
    }
    return GameTurn(activeCardIndex, tile, playerResults, rolled);
  }

  GameTurn setActionResult(int cardIndex, ActionResult result) {
    final newResults = List<ActionResult>.from(playerResults);
    newResults[cardIndex] = result;
    return GameTurn(
      activeCardIndex,
      activePlayerFirstMarkedTile,
      newResults,
      rolled,
    );
  }

  /*GameTurn setColoredActionResult(ActionResult result) {
    return GameTurn(activeCardIndex, result, whiteDiceResults, rolled);
  }

  GameTurn setWhiteActionResult(int cardIndex, ActionResult result) {
    final newResults = List<ActionResult>.from(whiteDiceResults);
    newResults[cardIndex] = result;
    return GameTurn(activeCardIndex, coloredDiceResult, newResults, rolled);
  }*/

  GameTurn setRolled(bool rolled) {
    return GameTurn(
      activeCardIndex,
      activePlayerFirstMarkedTile,
      playerResults,
      rolled,
    );
  }
}
