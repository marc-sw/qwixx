import 'package:qwixx/config/game.dart';
import 'package:qwixx/domain/command/gateway_command.dart';
import 'package:qwixx/domain/game/actor/actor.dart';
import 'package:qwixx/domain/game/game.dart';
import 'package:qwixx/main.dart';

class BotActor extends GameActor {
  bool dontReact = false;
  final ActionSelector _actionSelector = HeuristicsActionSelector();
  new(super.playerId, super.gateway, super.gameStateNotifier);

  @override
  void onGameStateChanged(GameState gameState) {
    if (dontReact) {
      return;
    }

    if (rollDiceCommand.isLegal(gameState)) {
      _dispatchDelayed(rollDiceCommand);
      return;
    }
    int cardIndex = gameState.cardIndexOf(playerId);
    if (cardIndex == -1 ||
        !gameState.turn.isAwaitingAction(cardIndex) ||
        gameState.phase != GamePhase.markNumber) {
      return;
    }

    final tile = _actionSelector.selectTile(
      cardTiles
          .where((tile) => MarkNumberCommand(playerId, tile).isLegal(gameState))
          .toList(),
      !gameState.turn.didAnyAction(cardIndex) &&
              gameState.turn.activeCardIndex == cardIndex
          ? -5
          : 0,
      gameState.cards[cardIndex],
    );

    if (tile != null) {
      _dispatchDelayed(MarkNumberCommand(playerId, tile));
    } else {
      _dispatchDelayed(skipTurnCommand);
    }
  }

  void _dispatchDelayed(GameCommand command) {
    dontReact = true;
    final delayMillis =
        random.nextInt(GameConfig.botActionVarDelay) +
        GameConfig.botActionMinDelay;
    Future.delayed(Duration(milliseconds: delayMillis), () {
      dontReact = false;
      dispatch(command);
    });
  }
}

abstract interface class ActionSelector {
  Tile? selectTile(List<Tile> legalTiles, int penalty, GameCard card);
}

class RandomActionSelector implements ActionSelector {
  @override
  Tile? selectTile(List<Tile> legalTiles, int penalty, GameCard card) {
    return legalTiles.firstOrNull;
  }
}

class HeuristicsActionSelector implements ActionSelector {
  @override
  Tile? selectTile(List<Tile> legalTiles, int penalty, GameCard card) {
    if (legalTiles.isEmpty) {
      return null;
    }

    final TileScore best = legalTiles
        .map((tile) {
          final s = score(tile, card);
          //print(s);
          return s;
        })
        .fold(
          TileScore(legalTiles.first, -999),
          (curr, next) => next.score > curr.score ? next : curr,
        );
    //print('chose: ${best.score >= penalty ? best : penalty}');
    //print("-----------");
    return best.score >= penalty ? best.tile : null;
  }

  TileScore score(Tile legalTile, GameCard card) {
    final row = card.rows[legalTile.color.index];
    final nextRow = row.markNumber(legalTile.number);
    final rowState = evaluate(row, NumberOrder.byColor(legalTile.color));
    final nextState = evaluate(nextRow, NumberOrder.byColor(legalTile.color));
    double s = switch ((rowState, nextState)) {
      (RowState.transient, RowState.transient) =>
        expectedRolls(row.markedNumbers, legalTile.color) -
            expectedRolls(nextRow.markedNumbers, legalTile.color),
      (RowState.transient, RowState.lockable) ||
      (RowState.lockable, RowState.lockable) => row.markedNumbers.length + 1,
      (RowState.lockable, RowState.locked) => 100,
      (RowState.transient, RowState.unlockable) => -100,
      (_, _) => throw AssertionError('illegal state $rowState to $nextState'),
    };
    return TileScore(legalTile, s);
  }

  RowState evaluate(GameRow row, NumberOrder order) {
    if (row.markedNumbers.length >= 5) {
      if (row.markedNumbers.last == 2 || row.markedNumbers.last == 12) {
        return RowState.locked;
      }
      return RowState.lockable;
    }
    if (row.markedNumbers.isEmpty) {
      return RowState.transient;
    }
    final normalizedLast = order.normalized(row.markedNumbers.last);
    if (normalizedLast + 5 - row.markedNumbers.length >= 12) {
      return RowState.unlockable;
    }
    return RowState.transient;
  }

  double expectedRolls(List<int> row, GameColor color) {
    if (row.isEmpty) {
      return 26.2;
    }

    if (row.length > 4) {
      throw AssertionError('expectedRoll works only on transient rows');
    }

    int lastMark = NumberOrder.byColor(color).normalized(row.last);
    if (lastMark + 5 - row.length >= 12) {
      throw AssertionError('can not expect rolls of unlockable state');
    }

    int lastMarkIndex = lastMark - 1 - row.length;
    double rolls = _expectedRolls[row.length - 1][lastMarkIndex];
    //print('expected: ${row.last} $color -> $rolls');
    return rolls;
  }
}

enum RowState { transient, lockable, locked, unlockable }

class TileScore {
  final Tile tile;
  final double score;

  const new(this.tile, this.score);

  @override
  String toString() {
    return 'TileScore($tile, $score)';
  }
}

const List<List<double>> _expectedRolls = [
  [17.7, 18.7, 20.5, 23.2, 29.4, 46.2],
  [8.8, 9.7, 12.9, 15.8, 23.4, 39.0],
  [4.3, 5, 6.7, 9.4, 16.2, 30],
  [1.4, 1.8, 2.6, 4, 7.2, 18],
];
