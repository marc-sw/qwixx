import 'package:flutter/foundation.dart';
import 'package:qwixx/domain/command/gateway_command.dart';
import 'package:qwixx/domain/game/actor/bot.dart';
import 'package:qwixx/domain/game/state.dart';
import 'package:qwixx/domain/lobby/lobby.dart';
import 'package:qwixx/domain/lobby/player.dart';
import 'package:qwixx/domain/user/user.dart';

class GatewayController {
  final User _user;
  final ValueNotifier<Lobby> _lobbyNotifier;
  final ValueNotifier<ValueNotifier<GameState>?> _gameStateNotifierNotifier;

  new(this._user, Lobby lobby)
    : _lobbyNotifier = ValueNotifier(lobby),
      _gameStateNotifierNotifier = ValueNotifier(null);

  User get user => _user;
  ValueListenable<Lobby> get lobbyListenable => _lobbyNotifier;
  ValueNotifier<ValueNotifier<GameState>?> get gameStateNotifierNotifier =>
      _gameStateNotifierNotifier;
  Lobby get lobby => _lobbyNotifier.value;
  ValueNotifier<GameState>? get gameStateNotifier =>
      _gameStateNotifierNotifier.value;
  GameState? get gameState => gameStateNotifier?.value;

  set _lobby(Lobby val) {
    _lobbyNotifier.value = val;
  }

  void dispatch(GatewayMessage message) {
    switch (message) {
      case LobbyCommand():
        if (message.isLegal(lobby)) {
          _lobby = message.execute(lobby);
        }
      case GameCommand():
        final notifier = gameStateNotifier;
        if (notifier != null && message.isLegal(notifier.value)) {
          notifier.value = message.execute(notifier.value);
        }
      case EventMessage():
        _handleEvents(message);
    }
  }

  void _handleEvents(EventMessage event) {
    switch (event) {
      case GameStateEvent(:final gameState):
        final notifier = gameStateNotifier;
        if (notifier != null) {
          notifier.value = gameState;
        } else {
          final newNotifier = ValueNotifier(gameState);
          gameStateNotifierNotifier.value = newNotifier;
          if (lobby.host.uuid == _user.uuid) {
            for (final player in lobby.all) {
              if (player.kind == PlayerKind.bot) {
                BotActor(player.uuid, this, newNotifier);
              }
            }
          }
        }
      case LobbyStateEvent(:final lobby):
        _lobby = lobby;
    }
  }
}
