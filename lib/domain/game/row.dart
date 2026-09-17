import 'dart:collection';

import 'package:qwixx/config/game.dart';
import 'package:qwixx/domain/game/card.dart';

class GameRow {
  final List<Number> _markedNumbers;

  const GameRow(this._markedNumbers);

  GameRow markNumber(Number number) {
    final newMarkedNumbers = List<Number>.from(_markedNumbers)..add(number);
    return GameRow(newMarkedNumbers);
  }

  List<Number> get markedNumbers => UnmodifiableListView(_markedNumbers);
  bool isMarked(Number number) {
    return _markedNumbers.contains(number);
  }

  int score() {
    int count = _markedNumbers.length;

    if (count > 0) {
      int last = _markedNumbers.last;
      if (count >= GameConfig.completeCountRequirement &&
          (last == GameConfig.highestNumber ||
              last == GameConfig.lowestNumber)) {
        count++;
      }
    }

    return switch (count) {
      1 => 1,
      2 => 3,
      3 => 6,
      4 => 10,
      5 => 15,
      6 => 21,
      7 => 28,
      8 => 36,
      9 => 45,
      10 => 55,
      11 => 66,
      12 => 78,
      _ => 0,
    };
  }
}
