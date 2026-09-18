import 'package:qwixx/domain/lobby/lobby.dart';
import 'package:qwixx/domain/lobby/player.dart';
import 'package:qwixx/domain/user/user.dart';
import 'package:qwixx/main.dart';

class LobbyUsecases {
  static final LobbyUsecases instance = LobbyUsecases();

  Lobby addPlayer(Player player, Lobby lobby) {
    final players = List<Player>.from(lobby.all);
    players.add(player);
    return lobby.copyWith(newPlayers: players);
  }

  Lobby removePlayer(int index, Lobby lobby) {
    if (index < 1 || lobby.all.length < 2) {
      return lobby;
    }
    final players = List<Player>.from(lobby.all);
    players.removeAt(index);
    return lobby.copyWith(newPlayers: players);
  }

  Lobby addBot(Lobby lobby) {
    final id = uuid.v4();
    int index = random.nextInt(botNames.length);
    int startIndex = index;
    while (lobby.all.any((user) => user.name == botNames[index])) {
      index = (index + 1) % botNames.length;
      if (index == startIndex) {
        throw Exception('no available bot name found');
      }
    }
    return addPlayer(Player(id, botNames[index], PlayerKind.bot), lobby);
  }

  Player createBot(Lobby lobby) {
    final id = uuid.v4();
    int index = random.nextInt(botNames.length);
    int startIndex = index;
    while (lobby.all.any((user) => user.name == botNames[index])) {
      index = (index + 1) % botNames.length;
      if (index == startIndex) {
        throw Exception('no available bot name found');
      }
    }
    return Player(id, botNames[index], PlayerKind.bot);
  }

  Lobby createLobby(User host) {
    return Lobby([Player(host.uuid, host.name, PlayerKind.host)]);
  }
}

const botNames = [
  'James',
  'William',
  'Henry',
  'Jack',
  'Oliver',
  'George',
  'Harry',
  'Charlie',
  'Thomas',
  'Arthur',
  'Edward',
  'Jacob',
  'Oscar',
  'Leo',
  'Ethan',
  'Daniel',
  'Samuel',
  'Benjamin',
  'Alexander',
  'Lucas',
  'Theodore',
  'Joseph',
  'Charles',
  'Frederick',
  'Alfie',
  'Archie',
  'Teddy',
  'Harrison',
  'Finley',
  'Adam',
  'Matthew',
  'David',
];
