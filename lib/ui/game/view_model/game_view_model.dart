import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:qwixx/data/repository/session/session_repository.dart';
import 'package:qwixx/domain/command/gateway_command.dart';
import 'package:qwixx/domain/game/actor/actor.dart';
import 'package:qwixx/domain/game/game.dart';
import 'package:qwixx/domain/gateway/gateway_controller.dart';
import 'package:qwixx/ui/game/view_model/card/card_tile_viewmodel.dart';
import 'package:qwixx/ui/game/view_model/card/card_viewmodel.dart';
import 'package:qwixx/ui/game/view_model/player_score.dart';

typedef ScoreMapper = List<PlayerScore> Function(GameCards cards);

class GameViewModel extends GameActor {
  final SessionRepository _session;
  final ValueNotifier<GameState> _gameStateNotifier;
  final GatewayController _gateway;
  List<CardViewModel> _cardViewModels;

  new(this._gameStateNotifier, this._gateway, this._session, String playerId)
    : _cardViewModels = [],
      super(playerId, _gateway, _gameStateNotifier) {
    _cardViewModels = [
      for (final card in _gameStateNotifier.value.cards)
        CardViewModel.init(
          card,
          (tile) => onTileV2Tap(card.player.uuid, tile),
          (index) => onFailTap(card.player.uuid, index),
          playerId == card.player.uuid,
        ),
    ];
  }

  ValueNotifier<GameState> get gameStateNotifier => _gameStateNotifier;
  GatewayController get gateway => _gateway;
  SessionRepository get session => _session;
  List<CardViewModel> get cardViewModels =>
      UnmodifiableListView(_cardViewModels);

  @override
  void onGameStateChanged(GameState gameState) {
    int myCardIndex = gameState.cardIndexOf(playerId);
    for (int cardIndex = 0; cardIndex < _cardViewModels.length; cardIndex++) {
      for (
        int rowIndex = 0;
        rowIndex < _cardViewModels[cardIndex].cardRowViewModels.length;
        rowIndex++
      ) {
        _cardViewModels[cardIndex]
            .cardRowViewModels[rowIndex]
            .scoreListenable
            .value = gameState.cards[cardIndex].rows[rowIndex]
            .score();
        for (
          int tileIndex = 0;
          tileIndex <
              _cardViewModels[cardIndex]
                  .cardRowViewModels[rowIndex]
                  .cardTileViewModels
                  .length;
          tileIndex++
        ) {
          final tile = _cardViewModels[cardIndex]
              .cardRowViewModels[rowIndex]
              .cardTileViewModels[tileIndex];

          if (gameState.cards[cardIndex].rows[rowIndex].markedNumbers.contains(
            tile.tile.number,
          )) {
            tile.decorationListenable.value = TileDecoration.marked;
          } else if (!gameState.diceRolls.colored.containsKey(
            tile.tile.color,
          )) {
            tile.decorationListenable.value = TileDecoration.skipped;
          } else if (cardIndex != myCardIndex) {
            tile.decorationListenable.value = TileDecoration.none;
          } else {
            final cmd = MarkNumberCommand(playerId, tile.tile);
            if (cmd.isLegal(gameState)) {
              tile.decorationListenable.value = TileDecoration.markable;
            } else {
              tile.decorationListenable.value = TileDecoration.none;
            }
          }
        }
      }

      for (
        int failIndex = 0;
        failIndex < _cardViewModels[cardIndex].failDecorationListenables.length;
        failIndex++
      ) {
        final failDeco =
            _cardViewModels[cardIndex].failDecorationListenables[failIndex];
        if (gameState.cards[cardIndex].misses > failIndex) {
          failDeco.value = FailDecoration.marked;
        } else if (cardIndex == myCardIndex &&
            gameState.turn.activeCardIndex == cardIndex &&
            !gameState.turn.didAnyAction(cardIndex) &&
            failIndex == gameState.activeCard.misses &&
            gameState.turn.rolled) {
          failDeco.value = FailDecoration.markable;
        } else {
          failDeco.value = FailDecoration.none;
        }
      }

      _cardViewModels[cardIndex].failScoreListenable.value =
          gameState.cards[cardIndex].missScore;
      _cardViewModels[cardIndex].resultScoreListenable.value =
          gameState.cards[cardIndex].score;
    }
  }

  void deleteGame() {
    _gateway.gameStateNotifierNotifier.value = null;
  }

  void deleteGateway() {
    _session.gatewayController = null;
  }

  void onTileV2Tap(String cardPlayerId, Tile tile) {
    if (playerId != cardPlayerId) {
      return;
    }
    dispatch(MarkNumberCommand(cardPlayerId, tile));
  }

  void onFailTap(String cardPlayerId, int index) {
    if (playerId != cardPlayerId) {
      return;
    }
    int cardIndex = _gameStateNotifier.value.cardIndexOf(playerId);
    if (cardIndex == -1) {
      return;
    }
    if (_gameStateNotifier.value.cards[cardIndex].misses != index) {
      return;
    }
    dispatch(skipTurnCommand);
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
          for (var i = 0; i < gameState.turn.playerResults.length; i++)
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
}
