part of '../gateway_command.dart';

@JsonSerializable(explicitToJson: true)
class JoinCommand extends LobbyCommand {
  final String name;
  final PlayerKind kind;

  const new(super.issuerId, this.name, this.kind);
  factory JoinCommand.fromJson(Map<String, dynamic> json) =>
      _$JoinCommandFromJson(json);
  Map<String, dynamic> toJson() => _$JoinCommandToJson(this);

  @override
  Lobby execute(Lobby lobby) {
    final newList = List<Player>.from(lobby.all);
    newList.add(Player(issuerId, name, kind));
    return lobby.copyWith(newPlayers: newList);
  }

  @override
  bool isLegal(Lobby lobby) {
    return !lobby.all.any((player) => player.uuid == issuerId);
  }
}

@JsonSerializable(explicitToJson: true)
class LeaveCommand extends LobbyCommand {
  new(super.issuerId);
  factory LeaveCommand.fromJson(Map<String, dynamic> json) =>
      _$LeaveCommandFromJson(json);
  Map<String, dynamic> toJson() => _$LeaveCommandToJson(this);

  @override
  Lobby execute(Lobby lobby) {
    final newList = List<Player>.from(lobby.all);
    newList.removeWhere((player) => player.uuid == issuerId);
    return lobby.copyWith(newPlayers: newList);
  }

  @override
  bool isLegal(Lobby lobby) {
    return lobby.host.uuid != issuerId &&
        lobby.all.any((player) => player.uuid == issuerId);
  }
}

@JsonSerializable(explicitToJson: true)
class KickCommand extends LobbyCommand {
  final String targetId;
  const new(super.issuerId, this.targetId);
  factory KickCommand.fromJson(Map<String, dynamic> json) =>
      _$KickCommandFromJson(json);
  Map<String, dynamic> toJson() => _$KickCommandToJson(this);

  @override
  Lobby execute(Lobby lobby) {
    final newList = List<Player>.from(lobby.all);
    newList.removeWhere((player) => player.uuid == targetId);
    return lobby.copyWith(newPlayers: newList);
  }

  @override
  bool isLegal(Lobby lobby) {
    return issuerId == lobby.host.uuid &&
        targetId != issuerId &&
        lobby.all.any((player) => player.uuid == targetId);
  }
}
