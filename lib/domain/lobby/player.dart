import 'package:json_annotation/json_annotation.dart';
import 'package:qwixx/domain/user/user.dart';

part 'player.g.dart';

enum PlayerKind { host, client, bot }

@JsonSerializable(explicitToJson: true)
class Player extends User {
  final PlayerKind kind;
  new(super.uuid, super.name, this.kind);
  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$PlayerToJson(this);
}
