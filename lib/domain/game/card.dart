import 'dart:collection';

import 'package:qwixx/config/game.dart';
import 'package:qwixx/domain/game/color.dart';
import 'package:qwixx/domain/game/row.dart';
import 'package:qwixx/domain/lobby/player.dart';

typedef Number = int;

typedef MarkedNumbers = List<GameRow>;

class GameCard {
  final Player _player;
  final List<GameRow> _rows;
  final int _misses;

  const GameCard({
    required this._player,
    required this._rows,
    required this._misses,
  });

  Player get player => _player;
  String get name => _player.name;
  List<GameRow> get rows => UnmodifiableListView(_rows);
  int get misses => _misses;
  int get missScore => _misses * GameConfig.missValue;
  int get score =>
      _rows.map((row) => row.score()).fold(0, (val, element) => val + element) -
      missScore;

  bool canMarkNumber(GameColor color, Number number) {
    final row = _rows[color.index];
    int index = NumberOrder.byColor(color).indexOf(number);
    if (index == GameConfig.lastRowIndex) {
      return row.markedNumbers.length >= GameConfig.completeCountRequirement &&
          row.markedNumbers.last != number;
    }
    return row.markedNumbers.isEmpty ||
        NumberOrder.byColor(color).indexOf(row.markedNumbers.last) < index;
  }

  GameCard markNumber(GameColor color, Number number) {
    GameRow newRow = _rows[color.index].markNumber(number);
    List<GameRow> newRows = List<GameRow>.from(_rows);
    newRows[color.index] = newRow;
    return GameCard(player: player, rows: newRows, misses: _misses);
  }

  GameCard increaseMisses() {
    return GameCard(player: player, rows: rows, misses: misses + 1);
  }
}
