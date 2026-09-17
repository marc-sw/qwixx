import 'package:qwixx/config/game.dart';
import 'package:qwixx/domain/game/action.dart';
import 'package:qwixx/domain/game/card.dart';
import 'package:qwixx/domain/game/color.dart';
import 'package:qwixx/domain/game/state.dart';
import 'package:qwixx/domain/lobby/lobby.dart';
import 'package:qwixx/domain/lobby/player.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lobby/lobby_command.dart';
part 'game/mark_number.dart';
part 'game/roll_dice.dart';
part 'game/skip_turn.dart';
part 'event/game_state.dart';
part 'event/lobby_state.dart';

sealed class GatewayMessage {
  const new();
}

sealed class LobbyCommand extends GatewayMessage {
  final String issuerId;
  const new(this.issuerId);

  bool isLegal(Lobby lobby);
  Lobby execute(Lobby lobby);
}

sealed class GameCommand extends GatewayMessage {
  final String issuerId;
  const new(this.issuerId);

  bool isLegal(GameState gameState);
  GameState execute(GameState gameState);
}

sealed class EventMessage extends GatewayMessage {
  const new();
}
