part of '../gateway_command.dart';

@JsonSerializable(explicitToJson: true)
class LobbyStateEvent extends EventMessage {
  final Lobby lobby;

  const new(this.lobby);
  factory LobbyStateEvent.fromJson(Map<String, dynamic> json) =>
      _$LobbyStateEventFromJson(json);
  Map<String, dynamic> toJson() => _$LobbyStateEventToJson(this);
}
