part of 'game.dart';

typedef WhiteRolls = List<int>;
typedef ColoredRolls = Map<GameColor, int>;

@JsonSerializable(explicitToJson: true)
class Tile {
  final GameColor color;
  final Number number;
  const new(this.color, this.number);
  factory Tile.fromJson(Map<String, dynamic> json) => _$TileFromJson(json);
  Map<String, dynamic> toJson() => _$TileToJson(this);

  @override
  bool operator ==(Object other) {
    // TODO: implement ==
    return super == other ||
        other is Tile && other.color == color && other.number == number;
  }
}

@JsonSerializable(explicitToJson: true)
class DiceRolls {
  final WhiteRolls white;
  final ColoredRolls colored;
  final List<Tile> whiteTargets;
  final List<Tile> coloredTargets;

  const DiceRolls(
    this.white,
    this.colored,
    this.whiteTargets,
    this.coloredTargets,
  );
  factory DiceRolls.fromJson(Map<String, dynamic> json) =>
      _$DiceRollsFromJson(json);
  Map<String, dynamic> toJson() => _$DiceRollsToJson(this);

  DiceRolls.init()
    : white = [5, 6],
      colored = LinkedHashMap.from({
        GameColor.red: 1,
        GameColor.yellow: 2,
        GameColor.green: 3,
        GameColor.blue: 4,
      }),
      whiteTargets = [],
      coloredTargets = [];

  List<int> get distinctWhite =>
      white.first == white.last ? [white.first] : white;
  int get coloredCount => colored.length;
  int get whiteSum => white.fold(0, (sum, roll) => sum + roll);

  bool hasColor(GameColor color) {
    return colored.containsKey(color);
  }

  bool hasColoredSum(GameColor color, int sum) {
    if (!hasColor(color)) {
      return false;
    }
    final roll = colored[color]!;
    return white.any((whiteRoll) => whiteRoll + roll == sum);
  }

  int _randomRoll() {
    return random.nextInt(6) + 1;
  }

  DiceRolls roll() {
    final newWhite = WhiteRolls.generate(white.length, (_) => _randomRoll());
    final ColoredRolls newColored = Map.from(colored);

    for (final color in newColored.keys) {
      newColored[color] = _randomRoll();
    }
    return DiceRolls(
      newWhite,
      newColored,
      _generateWhiteTargets(newWhite, newColored),
      _generateColoredTargets(newWhite, newColored),
    );
  }

  DiceRolls removeColoredDice(GameColor color) {
    if (!hasColor(color)) {
      return this;
    }
    final newColored = Map<GameColor, int>.from(colored);
    newColored.remove(color);
    return DiceRolls(
      white,
      newColored,
      _generateWhiteTargets(white, newColored),
      _generateColoredTargets(white, newColored),
    );
  }

  List<Tile> _generateWhiteTargets(List<int> white_, ColoredRolls colored_) {
    return colored_.keys
        .map((color) => Tile(color, white_.fold(0, (a, b) => a + b)))
        .toList();
  }

  List<Tile> _generateColoredTargets(List<int> white_, ColoredRolls colored_) {
    final distinct = white_.first == white_.last ? [white_.first] : white_;
    return distinct
        .expand(
          (roll) => colored_.entries.map(
            (entry) => Tile(entry.key, roll + entry.value),
          ),
        )
        .toList();
  }
}
