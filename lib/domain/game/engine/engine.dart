import 'package:qwixx/domain/command/gateway_command.dart';
import 'package:qwixx/domain/game/state.dart';

class GameEngine {
  static final GameEngine instance = GameEngine();

  GameState executeCommand(GameCommand command, GameState gameState) {
    if (!command.isLegal(gameState)) {
      return gameState;
    }
    return command.execute(gameState);
  }
}
