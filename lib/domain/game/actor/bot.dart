import 'package:qwixx/config/game.dart';
import 'package:qwixx/domain/command/gateway_command.dart';
import 'package:qwixx/domain/game/actor/actor.dart';
import 'package:qwixx/domain/game/state.dart';
import 'package:qwixx/main.dart';

class BotActor extends GameActor {
  new(super.playerId, super.gateway, super.gameStateNotifier);

  @override
  void onGameStateChanged(GameState gameState) {
    if (rollDiceCommand.isLegal(gameState)) {
      _dispatchDelayed(rollDiceCommand);
      return;
    }
    for (final list in markNumberCommands) {
      for (final cmd in list) {
        if (cmd.isLegal(gameState)) {
          _dispatchDelayed(cmd);
          return;
        }
      }
    }
    if (skipTurnCommand.isLegal(gameState)) {
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
