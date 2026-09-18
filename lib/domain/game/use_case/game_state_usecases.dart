import 'package:qwixx/domain/game/game.dart';
import 'package:qwixx/domain/lobby/lobby.dart';
import 'package:qwixx/main.dart';

class GameStateUsecases {
  static final GameStateUsecases instance = GameStateUsecases();

  GameState createGameStateFromLobby(Lobby lobby) {
    final state = GameState.init(lobby.all, random.nextInt(lobby.all.length));
    return state;
  }
}
