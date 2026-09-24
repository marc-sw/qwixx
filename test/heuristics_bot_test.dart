import 'package:flutter_test/flutter_test.dart';
import 'package:qwixx/domain/game/actor/bot.dart';
import 'package:qwixx/domain/game/game.dart';
import 'package:qwixx/domain/lobby/player.dart';

void main() {
  test('Selector should select', () {
    final selecter = HeuristicsActionSelector();
    final legalTiles = [Tile(GameColor.blue, 8), Tile(GameColor.green, 8)];
    final card = GameCard(
      player: Player('abc', 'marc', PlayerKind.host),
      rows: [
        GameRow([]),
        GameRow([]),
        GameRow([11, 10]),
        GameRow([]),
      ],
      misses: 0,
    );
    final tile = selecter.selectTile(legalTiles, 0, card);
    expect(tile, Tile(GameColor.green, 8));
  });
}
