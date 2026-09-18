part of '../gateway_command.dart';

@JsonSerializable(explicitToJson: true)
class GameStateEvent extends EventMessage {
  final GameState gameState;

  const new(this.gameState);
  factory GameStateEvent.fromJson(Map<String, dynamic> json) =>
      _$GameStateEventFromJson(json);
  Map<String, dynamic> toJson() => _$GameStateEventToJson(this);
}
