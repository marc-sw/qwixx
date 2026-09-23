part of 'game.dart';

enum GameColor {
  red,
  yellow,
  green,
  blue;

  static GameColor byIndex(int index) {
    return switch (index) {
      0 => red,
      1 => yellow,
      2 => green,
      3 => blue,
      _ => throw UnimplementedError(),
    };
  }

  NumberOrder get numberOrder => switch (this) {
    GameColor.red || GameColor.yellow => NumberOrder.ascending,
    GameColor.green || GameColor.blue => NumberOrder.descending,
  };

  Iterable<int> get range => switch (numberOrder) {
    NumberOrder.ascending => _range(
      GameConfig.lowestNumber,
      GameConfig.highestNumber,
    ),
    NumberOrder.descending => _range(
      GameConfig.highestNumber,
      GameConfig.lowestNumber,
    ),
  };
}

enum NumberOrder {
  ascending,
  descending;

  static NumberOrder byColor(GameColor color) {
    return switch (color) {
      GameColor.red || GameColor.yellow => NumberOrder.ascending,
      GameColor.green || GameColor.blue => NumberOrder.descending,
    };
  }

  int numberAt(int index) {
    return switch (this) {
      NumberOrder.ascending => index + GameConfig.lowestNumber,
      NumberOrder.descending => GameConfig.highestNumber - index,
    };
  }

  int indexOf(int number) {
    return switch (this) {
      NumberOrder.ascending => number - GameConfig.lowestNumber,
      NumberOrder.descending => GameConfig.highestNumber - number,
    };
  }
}

Iterable<int> _range(int start, int end) sync* {
  final step = start <= end ? 1 : -1;

  for (var i = start; ; i += step) {
    yield i;
    if (i == end) break;
  }
}
