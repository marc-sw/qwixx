import 'package:qwixx/config/game.dart';
import 'package:qwixx/domain/command/gateway_command.dart';
import 'package:qwixx/domain/game/actor/actor.dart';
import 'package:qwixx/domain/game/game.dart';
import 'package:qwixx/main.dart';

class BotActor extends GameActor {
  final ActionSelector _actionSelector = RandomActionSelector();
  new(super.playerId, super.gateway, super.gameStateNotifier);

  @override
  void onGameStateChanged(GameState gameState) {
    if (rollDiceCommand.isLegal(gameState)) {
      _dispatchDelayed(rollDiceCommand);
      return;
    }
    int cardIndex = gameState.cardIndexOf(playerId);
    if (cardIndex == -1 || !gameState.turn.isAwaitingAction(cardIndex)) {
      return;
    }

    final tile = _actionSelector.selectTile(
      cardTiles
          .where((tile) => MarkNumberCommand(playerId, tile).isLegal(gameState))
          .toList(),
      gameState.turn.isFailThrow(cardIndex) ? -5 : 0,
    );

    if (tile != null) {
      _dispatchDelayed(MarkNumberCommand(playerId, tile));
    } else {
      _dispatchDelayed(skipTurnCommand);
    }
  }

  void _dispatchDelayed(GameCommand command) {
    final delayMillis =
        random.nextInt(GameConfig.botActionVarDelay) +
        GameConfig.botActionMinDelay;
    //print('bot will dispatch in ${delayMillis}ms');
    Future.delayed(
      Duration(milliseconds: delayMillis),
      () => dispatch(command),
    );
  }
}

abstract interface class ActionSelector {
  Tile? selectTile(List<Tile> legalTiles, int penalty);
}

class RandomActionSelector implements ActionSelector {
  @override
  Tile? selectTile(List<Tile> legalTiles, int penalty) {
    return legalTiles.firstOrNull;
  }
}
