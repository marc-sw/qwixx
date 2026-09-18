import 'package:flutter/foundation.dart';
import 'package:qwixx/data/repository/session/session_repository.dart';
import 'package:qwixx/domain/game/actor/actor.dart';
import 'package:qwixx/domain/game/game.dart';
import 'package:qwixx/domain/gateway/gateway_controller.dart';
import 'package:qwixx/ui/game/view_model/player_score.dart';

typedef ScoreMapper = List<PlayerScore> Function(GameCards cards);

class GameViewModel extends GameActor {
  final SessionRepository _session;
  final ValueNotifier<GameState> _gameStateNotifier;
  final GatewayController _gateway;

  new(this._gameStateNotifier, this._gateway, this._session, String playerId)
    : super(playerId, _gateway, _gameStateNotifier);

  ValueNotifier<GameState> get gameStateNotifier => _gameStateNotifier;
  GatewayController get gateway => _gateway;
  SessionRepository get session => _session;

  void deleteGame() {
    _gateway.gameStateNotifierNotifier.value = null;
  }

  void deleteGateway() {
    _session.gatewayController = null;
  }

  void onTileTap(String cardPlayerId, int column, int row) {
    if (playerId != cardPlayerId) {
      return;
    }
    dispatch(markNumberCommands[column][row]);
  }

  void onSkipTap() {
    dispatch(skipTurnCommand);
  }

  void onMissTap(String cardPlayerId) {
    if (playerId == cardPlayerId) {
      onSkipTap();
    }
  }

  void onDiceRoll() {
    dispatch(rollDiceCommand);
  }

  bool canRoll() {
    return rollDiceCommand.isLegal(gameStateNotifier.value);
  }

  bool canSkip() {
    return skipTurnCommand.isLegal(gameStateNotifier.value);
  }

  String generateInfoText(GameState gameState) {
    return switch (gameState.phase) {
      GamePhase.rollDice => () {
        if (rollDiceCommand.isLegal(gameState)) {
          return 'Du bist dran mit würfeln.';
        }
        String displayName =
            gameState.cards[gameState.turn.activeCardIndex].name;
        return 'Warte bis $displayName gewürfelt hat.';
      }(),
      GamePhase.markNumber => () {
        if (skipTurnCommand.isLegal(gameState)) {
          return 'Markiere Nummern oder drücke fertig';
        }
        List<String> awaitingNames = [
          for (var i = 0; i < gameState.turn.whiteDiceResults.length; i++)
            if (gameState.turn.isAwaitingAction(i)) gameState.cards[i].name,
        ];
        if (awaitingNames.length == 1) {
          return 'Warte bis ${awaitingNames.first} fertig ist.';
        }
        String names =
            '${awaitingNames.sublist(0, awaitingNames.length - 1).join(', ')} und ${awaitingNames.last}';
        return 'Warte bis $names fertig sind.';
      }(),
      GamePhase.gameOver => 'Das Spiel ist vorbei.',
    };
  }

  List<PlayerScore> generatePlayerScores(GameCards cards) {
    return cards
        .map(
          (card) => PlayerScore(
            card.player,
            card.score,
            card.rows[GameColor.red.index].score(),
            card.rows[GameColor.yellow.index].score(),
            card.rows[GameColor.green.index].score(),
            card.rows[GameColor.blue.index].score(),
            card.missScore,
          ),
        )
        .toList()
      ..sort((a, b) => b.score - a.score);
  }

  @override
  void onGameStateChanged(GameState gameState) {}
}
