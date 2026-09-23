part of 'game.dart';

typedef GameCards = List<GameCard>;
typedef ActionResults = List<ActionResult>;

enum GamePhase { rollDice, markNumber, gameOver }

@JsonSerializable(explicitToJson: true)
class GameState {
  final GameCards cards;
  final DiceRolls diceRolls;
  final GameTurn turn;

  const GameState({
    required this.cards,
    required this.diceRolls,
    required this.turn,
  });
  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);
  Map<String, dynamic> toJson() => _$GameStateToJson(this);

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

  int get maxMisses =>
      cards.map((card) => card.misses).reduce((a, b) => a > b ? a : b);
  bool get isGameOver => diceRolls.coloredCount < 3 || maxMisses >= 4;
  GamePhase get phase => isGameOver
      ? GamePhase.gameOver
      : !turn.rolled
      ? GamePhase.rollDice
      : GamePhase.markNumber;

  GameCards setCard(int index, GameCard newCard) {
    final newCards = List<GameCard>.from(cards);
    newCards[index] = newCard;
    return newCards;
  }

  GameCards increaseMisses(int cardIndex) {
    return setCard(cardIndex, cards[cardIndex].increaseMisses());
  }

  int cardIndexOf(String playerId) {
    return cards.indexWhere((card) => card.player.uuid == playerId);
  }

  int cardIndexOfHighestScore() {
    int index = -1;
    int score = -1;

    for (int i = 0; i < cards.length; i++) {
      if (cards[i].score > score) {
        score = cards[i].score;
        index = i;
      }
    }
    return index;
  }

  GameCard get activeCard => cards[turn.activeCardIndex];

  GameState copyWith({
    GameCards? newCards,
    DiceRolls? newDiceRolls,
    GameTurn? newTurn,
  }) {
    return GameState(
      cards: newCards ?? cards,
      diceRolls: newDiceRolls ?? diceRolls,
      turn: newTurn ?? turn,
    );
  }
}
