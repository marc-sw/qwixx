import 'dart:collection';

import 'package:qwixx/domain/game/card.dart';
import 'package:qwixx/domain/game/color.dart';
import 'package:qwixx/main.dart';

typedef WhiteRolls = List<int>;
typedef ColoredRolls = Map<GameColor, int>;
typedef Tile = ({GameColor color, Number number});

class DiceRolls {
  final WhiteRolls _white;
  final ColoredRolls _colored;
  final List<Tile> _whiteTargets;
  final List<Tile> _coloredTargets;

  const DiceRolls(
    this._white,
    this._colored,
    this._whiteTargets,
    this._coloredTargets,
  );

  DiceRolls.init()
    : _white = [5, 6],
      _colored = LinkedHashMap.from({
        GameColor.red: 1,
        GameColor.yellow: 2,
        GameColor.green: 3,
        GameColor.blue: 4,
      }),
      _whiteTargets = [],
      _coloredTargets = [];

  List<int> get white => UnmodifiableListView(_white);
  List<int> get distinctWhite =>
      _white.first == _white.last ? [_white.first] : _white;
  Map<GameColor, int> get colored => UnmodifiableMapView(_colored);
  int get coloredCount => _colored.length;
  int get whiteSum => _white.fold(0, (sum, roll) => sum + roll);

  bool hasColor(GameColor color) {
    return _colored.containsKey(color);
  }

  bool hasColoredSum(GameColor color, int sum) {
    if (!hasColor(color)) {
      return false;
    }
    final roll = _colored[color]!;
    return _white.any((whiteRoll) => whiteRoll + roll == sum);
  }

  int _randomRoll() {
    return random.nextInt(6) + 1;
  }

  DiceRolls roll() {
    final white = WhiteRolls.generate(_white.length, (_) => _randomRoll());
    final ColoredRolls colored = Map.from(_colored);

    for (final color in colored.keys) {
      colored[color] = _randomRoll();
    }
    return DiceRolls(
      white,
      colored,
      _generateWhiteTargets(white, colored),
      _generateColoredTargets(white, colored),
    );
  }

  DiceRolls removeColoredDice(GameColor color) {
    if (!hasColor(color)) {
      return this;
    }
    final newColored = Map<GameColor, int>.from(_colored);
    newColored.remove(color);
    return DiceRolls(
      _white,
      newColored,
      _generateWhiteTargets(_white, newColored),
      _generateColoredTargets(_white, newColored),
    );
  }

  List<Tile> _generateWhiteTargets(List<int> white, ColoredRolls colored) {
    return colored.keys
        .map((color) => (color: color, number: white.fold(0, (a, b) => a + b)))
        .toList();
  }

  List<Tile> _generateColoredTargets(List<int> white, ColoredRolls colored) {
    final distinct = white.first == white.last ? [white.first] : white;
    return distinct
        .expand(
          (roll) => colored.entries.map(
            (entry) => (color: entry.key, number: roll + entry.value),
          ),
        )
        .toList();
  }

  List<Tile> get whiteTargets => _whiteTargets;

  List<Tile> get coloredTargets => _coloredTargets;
}
