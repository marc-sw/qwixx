import 'package:bit_array/bit_array.dart';
import 'package:qwixx/domain/gameV2/entity/number_order.dart';

enum Color {
  red(NumberOrder.ascending),
  yellow(NumberOrder.ascending),
  green(NumberOrder.descending),
  blue(NumberOrder.descending);

  final NumberOrder _numberOrder;
  NumberOrder get numberOrder => _numberOrder;

  const new(this._numberOrder);
}

enum Number {
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  eleven,
  twelve,
}

final colorCount = Color.values.length;
final numberCount = Number.values.length;

class Tile {
  final Color color;
  final Number number;
  const new({required this.color, required this.number});

  int get index =>
      numberCount * color.index + color.numberOrder.indexOf(number);
}

class Card {
  final BitArray _bitArray;
  int _misses;

  new({required this._bitArray, required this._misses});

  bool isMarked(Tile tile) {
    return _bitArray[tile.index];
  }

  bool isNthMarked(Color color, int nth) {
    return _bitArray[numberCount * color.index + nth];
  }

  bool isLastNthMarked(Color color, int lastNth) {
    return _bitArray[numberCount * (color.index + 1) - lastNth - 1];
  }

  bool isLastMarked(Color color) {
    return isLastNthMarked(color, numberCount - 1);
  }

  void mark(Tile tile) {
    _bitArray[tile.index] = true;
  }

  void unmark(Tile tile) {
    _bitArray[tile.index] = false;
  }

  int get misses => _misses;

  void setMisses(int value) {
    _misses = value;
  }

  void increaseMisses() {
    _misses++;
  }
}
