part of 'game.dart';

typedef Number = int;

typedef MarkedNumbers = List<GameRow>;

@JsonSerializable(explicitToJson: true)
class GameCard {
  final Player player;
  final List<GameRow> rows;
  final int misses;

  const GameCard({
    required this.player,
    required this.rows,
    required this.misses,
  });
  factory GameCard.fromJson(Map<String, dynamic> json) =>
      _$GameCardFromJson(json);
  Map<String, dynamic> toJson() => _$GameCardToJson(this);

  String get name => player.name;
  int get missScore => misses * GameConfig.missValue;
  int get score =>
      rows.map((row) => row.score()).fold(0, (val, element) => val + element) -
      missScore;

  bool canMarkNumber(GameColor color, Number number) {
    final row = rows[color.index];
    int index = NumberOrder.byColor(color).indexOf(number);
    if (index == GameConfig.lastRowIndex) {
      return row.markedNumbers.length >= GameConfig.completeCountRequirement &&
          row.markedNumbers.last != number;
    }
    return row.markedNumbers.isEmpty ||
        NumberOrder.byColor(color).indexOf(row.markedNumbers.last) < index;
  }

  GameCard markNumber(GameColor color, Number number) {
    GameRow newRow = rows[color.index].markNumber(number);
    List<GameRow> newRows = List<GameRow>.from(rows);
    newRows[color.index] = newRow;
    return GameCard(player: player, rows: newRows, misses: misses);
  }

  GameCard increaseMisses() {
    return GameCard(player: player, rows: rows, misses: misses + 1);
  }
}
