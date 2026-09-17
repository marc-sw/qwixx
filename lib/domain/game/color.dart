import 'package:qwixx/config/game.dart';

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
