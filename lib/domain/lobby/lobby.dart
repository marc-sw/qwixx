import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';
import 'package:qwixx/domain/lobby/player.dart';

part 'lobby.g.dart';

@JsonSerializable(explicitToJson: true)
class Lobby {
  final List<Player> players;

  const new(this.players);
  factory Lobby.fromJson(Map<String, dynamic> json) => _$LobbyFromJson(json);
  Map<String, dynamic> toJson() => _$LobbyToJson(this);

  Player get host => players.first;
  List<Player> get all => UnmodifiableListView(players);

  Lobby copyWith({List<Player>? newPlayers}) {
    return Lobby(newPlayers ?? players);
  }
}
