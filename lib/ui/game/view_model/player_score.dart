import 'package:qwixx/domain/lobby/player.dart';

class PlayerScore {
  final Player player;
  final int score;
  final int red;
  final int yellow;
  final int green;
  final int blue;
  final int fails;

  const new(
    this.player,
    this.score,
    this.red,
    this.yellow,
    this.green,
    this.blue,
    this.fails,
  );
}
