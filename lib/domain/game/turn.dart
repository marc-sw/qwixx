part of 'game.dart';

@JsonSerializable(explicitToJson: true)
class GameTurn {
  final int activeCardIndex;
  final ActionResult coloredDiceResult;
  final List<ActionResult> whiteDiceResults;
  final bool rolled;

  const GameTurn(
    this.activeCardIndex,
    this.coloredDiceResult,
    this.whiteDiceResults,
    this.rolled,
  );
  factory GameTurn.fromJson(Map<String, dynamic> json) =>
      _$GameTurnFromJson(json);
  Map<String, dynamic> toJson() => _$GameTurnToJson(this);

  factory GameTurn.init(int startingCardIndex, int cardCount) {
    return GameTurn(
      startingCardIndex,
      ActionResult.awaiting,
      List<ActionResult>.filled(cardCount, ActionResult.awaiting),
      false,
    );
  }

  bool isAwaitingAction(int cardIndex) {
    if (whiteDiceResults[cardIndex] == ActionResult.awaiting) {
      return true;
    }
    return activeCardIndex == cardIndex &&
        coloredDiceResult == ActionResult.awaiting;
  }

  bool isFailThrow(int cardIndex) {
    return cardIndex == activeCardIndex &&
        coloredDiceResult == ActionResult.skipped &&
        whiteDiceResults[cardIndex] == ActionResult.skipped;
  }

  bool isDone() {
    return coloredDiceResult != ActionResult.awaiting &&
        !whiteDiceResults.any((result) => result == ActionResult.awaiting);
  }

  bool canMarkWithColoredDice(int cardIndex) {
    return cardIndex == activeCardIndex &&
        coloredDiceResult == ActionResult.awaiting;
  }

  bool canMarkWithWhiteDice(int cardIndex) {
    return whiteDiceResults[cardIndex] == ActionResult.awaiting;
  }

  bool didAnyAction(int cardIndex) {
    return whiteDiceResults[cardIndex] != ActionResult.awaiting ||
        activeCardIndex == cardIndex &&
            coloredDiceResult != ActionResult.awaiting;
  }

  bool isActiveCard(int cardIndex) {
    return activeCardIndex == cardIndex;
  }

  GameTurn skipAction(int cardIndex) {
    List<ActionResult> white = whiteDiceResults;
    if (whiteDiceResults[cardIndex] == ActionResult.awaiting) {
      white = List.from(whiteDiceResults);
      white[cardIndex] = ActionResult.skipped;
    }

    ActionResult colored = coloredDiceResult;
    if (cardIndex == activeCardIndex &&
        coloredDiceResult == ActionResult.awaiting) {
      colored = ActionResult.skipped;
    }
    return GameTurn(activeCardIndex, colored, white, rolled);
  }

  GameTurn nextTurn() {
    final int nextCardIndex = (activeCardIndex + 1) % whiteDiceResults.length;
    return GameTurn(
      nextCardIndex,
      ActionResult.awaiting,
      List<ActionResult>.filled(whiteDiceResults.length, ActionResult.awaiting),
      false,
    );
  }

  GameTurn setColoredActionResult(ActionResult result) {
    return GameTurn(activeCardIndex, result, whiteDiceResults, rolled);
  }

  GameTurn setWhiteActionResult(int cardIndex, ActionResult result) {
    final newResults = List<ActionResult>.from(whiteDiceResults);
    newResults[cardIndex] = result;
    return GameTurn(activeCardIndex, coloredDiceResult, newResults, rolled);
  }

  GameTurn setRolled(bool rolled) {
    return GameTurn(
      activeCardIndex,
      coloredDiceResult,
      whiteDiceResults,
      rolled,
    );
  }
}
