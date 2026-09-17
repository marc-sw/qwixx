import 'dart:collection';

import 'package:qwixx/domain/game/action.dart';
import 'package:qwixx/domain/game/card.dart';
import 'package:qwixx/domain/game/rolls.dart';
import 'package:qwixx/domain/game/row.dart';
import 'package:qwixx/domain/game/turn.dart';
import 'package:qwixx/domain/lobby/player.dart';

typedef GameCards = List<GameCard>;
typedef ActionResults = List<ActionResult>;

enum GamePhase { rollDice, markNumber, gameOver }

class GameState {
  final GameCards _cards;
  final DiceRolls _diceRolls;
  final GameTurn _turn;

  const GameState({
    required this._cards,
    required this._diceRolls,
    required this._turn,
  });

  factory GameState.init(List<Player> players, int startingCardIndex) {
    final GameCards cards = players
        .map(
          (player) => GameCard(
            player: player,
            rows: List.generate(4, (_) => GameRow([])),
            misses: 0,
          ),
        )
        .toList();
    return GameState(
      cards: cards,
      diceRolls: DiceRolls.init(),
      turn: GameTurn.init(startingCardIndex, cards.length),
    );
  }

  GameCards get cards => UnmodifiableListView(_cards);
  DiceRolls get diceRolls => _diceRolls;
  GameTurn get turn => _turn;
  int get maxMisses =>
      _cards.map((card) => card.misses).reduce((a, b) => a > b ? a : b);
  bool get isGameOver => _diceRolls.coloredCount < 3 || maxMisses >= 4;
  GamePhase get phase => isGameOver
      ? GamePhase.gameOver
      : !turn.rolled
      ? GamePhase.rollDice
      : GamePhase.markNumber;

  GameCards setCard(int index, GameCard card) {
    final cards = List<GameCard>.from(_cards);
    cards[index] = card;
    return cards;
  }

  GameCards increaseMisses(int cardIndex) {
    return setCard(cardIndex, _cards[cardIndex].increaseMisses());
  }

  int cardIndexOf(String playerId) {
    return _cards.indexWhere((card) => card.player.uuid == playerId);
  }

  GameCard get activeCard => _cards[turn.activeCardIndex];

  GameState copyWith({
    GameCards? newCards,
    DiceRolls? newDiceRolls,
    GameTurn? newTurn,
  }) {
    return GameState(
      cards: newCards ?? _cards,
      diceRolls: newDiceRolls ?? _diceRolls,
      turn: newTurn ?? _turn,
    );
  }
}
