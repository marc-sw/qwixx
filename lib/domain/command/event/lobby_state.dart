part of '../gateway_command.dart';

@JsonSerializable(explicitToJson: true)
class LobbyStateEvent extends EventMessage {
  final Lobby lobby;

  const new(this.lobby);
}
