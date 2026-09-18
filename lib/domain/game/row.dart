part of 'game.dart';

@JsonSerializable(explicitToJson: true)
class GameRow {
  final List<Number> markedNumbers;

  const GameRow(this.markedNumbers);
  factory GameRow.fromJson(Map<String, dynamic> json) =>
      _$GameRowFromJson(json);
  Map<String, dynamic> toJson() => _$GameRowToJson(this);

  GameRow markNumber(Number number) {
    final newMarkedNumbers = List<Number>.from(markedNumbers)..add(number);
    return GameRow(newMarkedNumbers);
  }

  bool isMarked(Number number) {
    return markedNumbers.contains(number);
  }

  int score() {
    int count = markedNumbers.length;

    if (count > 0) {
      int last = markedNumbers.last;
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
