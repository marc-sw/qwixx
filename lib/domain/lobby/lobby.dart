import 'dart:collection';

import 'package:qwixx/domain/lobby/player.dart';

class Lobby {
  final List<Player> _players;

  const new(this._players);

  Player get host => _players.first;
  List<Player> get all => UnmodifiableListView(_players);

  Lobby copyWith({List<Player>? players}) {
    return Lobby(players ?? _players);
  }
}
