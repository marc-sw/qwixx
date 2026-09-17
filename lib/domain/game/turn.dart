import 'dart:collection';

import 'package:qwixx/domain/game/action.dart';

class GameTurn {
  final int _activeCardIndex;
  final ActionResult _coloredDiceResult;
  final List<ActionResult> _whiteDiceResults;
  final bool _rolled;

  const GameTurn(
    this._activeCardIndex,
    this._coloredDiceResult,
    this._whiteDiceResults,
    this._rolled,
  );

  factory GameTurn.init(int startingCardIndex, int cardCount) {
    return GameTurn(
      startingCardIndex,
      ActionResult.awaiting,
      List<ActionResult>.filled(cardCount, ActionResult.awaiting),
      false,
    );
  }

  int get activeCardIndex => _activeCardIndex;
  ActionResult get coloredDiceResult => _coloredDiceResult;
  List<ActionResult> get whiteDiceResults =>
      UnmodifiableListView(_whiteDiceResults);
  bool get rolled => _rolled;

  bool isAwaitingAction(int cardIndex) {
    if (whiteDiceResults[cardIndex] == ActionResult.awaiting) {
      return true;
    }
    return activeCardIndex == cardIndex &&
        coloredDiceResult == ActionResult.awaiting;
  }

  bool isFailThrow(int cardIndex) {
    return cardIndex == _activeCardIndex &&
        _coloredDiceResult == ActionResult.skipped &&
        _whiteDiceResults[cardIndex] == ActionResult.skipped;
  }

  bool isDone() {
    return _coloredDiceResult != ActionResult.awaiting &&
        !_whiteDiceResults.any((result) => result == ActionResult.awaiting);
  }

  bool canMarkWithColoredDice(int cardIndex) {
    return cardIndex == _activeCardIndex &&
        _coloredDiceResult == ActionResult.awaiting;
  }

  bool canMarkWithWhiteDice(int cardIndex) {
    return _whiteDiceResults[cardIndex] == ActionResult.awaiting;
  }

  bool didAnyAction(int cardIndex) {
    return _whiteDiceResults[cardIndex] != ActionResult.awaiting ||
        _activeCardIndex == cardIndex &&
            _coloredDiceResult != ActionResult.awaiting;
  }

  bool isActiveCard(int cardIndex) {
    return _activeCardIndex == cardIndex;
  }

  GameTurn skipAction(int cardIndex) {
    List<ActionResult> white = _whiteDiceResults;
    if (_whiteDiceResults[cardIndex] == ActionResult.awaiting) {
      white = List.from(_whiteDiceResults);
      white[cardIndex] = ActionResult.skipped;
    }

    ActionResult colored = _coloredDiceResult;
    if (cardIndex == activeCardIndex &&
        _coloredDiceResult == ActionResult.awaiting) {
      colored = ActionResult.skipped;
    }
    return GameTurn(_activeCardIndex, colored, white, _rolled);
  }

  GameTurn nextTurn() {
    final int nextCardIndex = (_activeCardIndex + 1) % _whiteDiceResults.length;
    return GameTurn(
      nextCardIndex,
      ActionResult.awaiting,
      List<ActionResult>.filled(
        _whiteDiceResults.length,
        ActionResult.awaiting,
      ),
      false,
    );
  }

  GameTurn setColoredActionResult(ActionResult result) {
    return GameTurn(_activeCardIndex, result, _whiteDiceResults, _rolled);
  }

  GameTurn setWhiteActionResult(int cardIndex, ActionResult result) {
    final newResults = List<ActionResult>.from(_whiteDiceResults);
    newResults[cardIndex] = result;
    return GameTurn(_activeCardIndex, _coloredDiceResult, newResults, _rolled);
  }

  GameTurn setRolled(bool rolled) {
    return GameTurn(
      _activeCardIndex,
      _coloredDiceResult,
      _whiteDiceResults,
      rolled,
    );
  }
}
