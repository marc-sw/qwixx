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
  final ValueNotifier<bool> _gameOverListenable;
  List<CardViewModel> _cardViewModels;

  new(this._gameStateNotifier, this._gateway, this._session, String playerId)
    : _cardViewModels = [],
      _gameOverListenable = ValueNotifier(false),
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
  ValueListenable<bool> get gameOverNotifier => _gameOverListenable;
  GatewayController get gateway => _gateway;
  SessionRepository get session => _session;
  List<CardViewModel> get cardViewModels =>
      UnmodifiableListView(_cardViewModels);

  @override
  void onGameStateChanged(GameState gameState) {
    _gameOverListenable.value = gameState.isGameOver;
    int myCardIndex = gameState.cardIndexOf(playerId);
    for (int cardIndex = 0; cardIndex < _cardViewModels.length; cardIndex++) {
      if (gameState.isGameOver) {
        _cardViewModels[cardIndex].statusListenable.value =
            StatusDecoration.done;
      } else if (!gameState.turn.rolled) {
        _cardViewModels[cardIndex].statusListenable.value =
            cardIndex == gameState.turn.activeCardIndex
            ? StatusDecoration.rolling
            : StatusDecoration.done;
      } else if (gameState.turn.isAwaitingAction(cardIndex)) {
        _cardViewModels[cardIndex].statusListenable.value =
            StatusDecoration.marking;
      } else {
        _cardViewModels[cardIndex].statusListenable.value =
            StatusDecoration.done;
      }
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
