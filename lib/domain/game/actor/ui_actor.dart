import 'package:qwixx/domain/game/actor/actor.dart';
import 'package:qwixx/domain/game/color.dart';
import 'package:qwixx/domain/game/state.dart';
import 'package:qwixx/domain/game/turn.dart';
import 'package:qwixx/ui/game/view_model/player_score.dart';

class UserInterfaceActor extends GameActor {
  new(super.gameSessionRepository, super.cardIndex, super.b);

  @override
  void onGameStateChanged(GameState gameState) {}

  void onTileTap(String cardPlayerId, int column, int row) {
    if (cardPlayerId != playerId) {
      return;
    }
    dispatch(markNumberCommands[column][row]);
  }

  void onSkipTap() {
    dispatch(skipTurnCommand);
  }

  void onMissTap(String cardPlayerId) {
    if (cardPlayerId == playerId) {
      onSkipTap();
    }
  }

  void onDiceRoll() {
    dispatch(rollDiceCommand);
  }

  bool canRoll(GameState gameState) {
    return rollDiceCommand.isLegal(gameState);
  }

  bool canSkip(GameState gameState) {
    return skipTurnCommand.isLegal(gameState);
  }

  String generateInfoText(GameTurn turn, GameState gameState) {
    return switch (gameState.phase) {
      GamePhase.rollDice => () {
        if (rollDiceCommand.isLegal(gameState)) {
          return 'Du bist dran mit würfeln.';
        }
        String displayName = gameState.cards[turn.activeCardIndex].name;
        return 'Warte bis $displayName gewürfelt hat.';
      }(),
      GamePhase.markNumber => () {
        if (skipTurnCommand.isLegal(gameState)) {
          return 'Markiere Nummern oder drücke fertig';
        }
        List<String> awaitingNames = [
          for (var i = 0; i < turn.whiteDiceResults.length; i++)
            if (turn.isAwaitingAction(i)) gameState.cards[i].name,
        ];
        if (awaitingNames.length == 1) {
          return 'Warte bis ${awaitingNames.first} fertig ist.';
        }
        String names =
            '${awaitingNames.sublist(0, awaitingNames.length - 1).join(', ')} und ${awaitingNames.last}';
        return 'Warte bis $names fertig';
      }(),
      GamePhase.gameOver => 'Das Spiel ist vorbei.',
    };
  }

  List<PlayerScore> sortedScores(GameCards cards) {
    return cards
        .map(
          (card) => PlayerScore(
            card.name,
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
}
