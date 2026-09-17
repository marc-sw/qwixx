import 'package:qwixx/domain/user/user.dart';

enum PlayerKind { host, client, bot }

class Player extends User {
  final PlayerKind _kind;

  new(super.uuid, super.name, this._kind);

  PlayerKind get kind => _kind;
}
