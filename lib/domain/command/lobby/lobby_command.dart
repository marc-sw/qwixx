part of '../gateway_command.dart';

class JoinCommand extends LobbyCommand {
  final String name;
  final PlayerKind kind;

  const new(super.issuerUUID, this.name, this.kind);

  @override
  Lobby execute(Lobby lobby) {
    final newList = List<Player>.from(lobby.all);
    newList.add(Player(issuerId, name, kind));
    return lobby.copyWith(players: newList);
  }

  @override
  bool isLegal(Lobby lobby) {
    return !lobby.all.any((player) => player.uuid == issuerId);
  }
}

class LeaveCommand extends LobbyCommand {
  new(super.issuerUUID);

  @override
  Lobby execute(Lobby lobby) {
    final newList = List<Player>.from(lobby.all);
    newList.removeWhere((player) => player.uuid == issuerId);
    return lobby.copyWith(players: newList);
  }

  @override
  bool isLegal(Lobby lobby) {
    return lobby.host.uuid != issuerId &&
        lobby.all.any((player) => player.uuid == issuerId);
  }
}

class KickCommand extends LobbyCommand {
  const new(super.issuerId, this.targetUUID);

  final String targetUUID;

  @override
  Lobby execute(Lobby lobby) {
    final newList = List<Player>.from(lobby.all);
    newList.removeWhere((player) => player.uuid == targetUUID);
    return lobby.copyWith(players: newList);
  }

  @override
  bool isLegal(Lobby lobby) {
    return issuerId == lobby.host.uuid &&
        targetUUID != issuerId &&
        lobby.all.any((player) => player.uuid == targetUUID);
  }
}
